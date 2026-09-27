{
  lib,
  fetchFromGitHub,
  buildPythonPackage,
  pythonOlder,
  setuptools,
  robotframework,
  robotframework-pythonlibcore,
  robotframework-assertion-engine,
  grpcio,
  overrides,
  click,
  seedir,
  wrapt,
  npmHooks,
  nodejs,
  fetchNpmDeps,
  node-pre-gyp,
  grpc-tools,
  grpcio-tools, # needed to generate --grpc_python_out + imported
  # For inv build
  invoke, # cmake-like for python
  mypy-protobuf,
  robotstatuschecker,
  pytest,
  beautifulsoup4,
  # To provide the binaries to the browsers + maintain the same version between playwright node
  # and playwright browsers
  playwright-driver,
}:
buildPythonPackage rec {
  pname = "robotframework-browser";
  version = "19.6.2";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "MarketSquare";
    repo = "robotframework-browser";
    tag = "v${version}";
    hash = "sha256-tSHaaSPiyjaw8OvlYyAT7VFcH/ymMRoNQzjZJIE2WU4=";
  };

  npmDeps = fetchNpmDeps {
    inherit src;
    hash = "sha256-zwEheWpvrKQZYqSarKuBvW/YGhayqs9oMU16bqK7Z/A=";
  };

  nativeBuildInputs = [
    npmHooks.npmConfigHook
    nodejs
    node-pre-gyp
    # For inv build. Maybe not really needed for build only
    invoke # cmake-like for python
    grpcio-tools # needed to generate --grpc_python_out
    grpc-tools # same for -m grpc_tools.protoc
    mypy-protobuf
    robotstatuschecker
    pytest
    beautifulsoup4
  ];

  build-system = [
    setuptools
  ];

  dependencies = [
    robotframework
    robotframework-pythonlibcore
    robotframework-assertion-engine
    grpcio
    overrides
    click
    seedir
    wrapt
  ];

  # We fake a run of rfbrowser init
  # + grpc_tools_node_protoc already includes the plugin and is not runnable via npm
  # since nix directly builds it from C++ sources to avoid to use pre-build binaries
  # downloaded by npm
  patchPhase = ''
    runHook prePatch
    substituteInPlace ./Browser/playwright.py \
      --replace-fail '(installation_dir / "node_modules").is_dir()' 'True'
    substituteInPlace ./tasks.py \
      --replace-fail 'c.run("pip install -U pip")' 'return' \
      --replace-fail 'npm run grpc_tools_node_protoc' 'grpc_tools_node_protoc' \
      --replace-fail ' -- ' ' '
    substituteInPlace ./package.json \
      --replace-fail '"grpc-tools": "^1.13.0",' ' '
    sed -i '/--plugin=protoc-gen-grpc/d' ./tasks.py
    runHook postPatch
  '';

  preBuild = ''
    inv build -d -e
  '';

  # - We first maintain the same version for playwright node and playwright binaries since playwright node
  #   hardcode the browser version. See https://discourse.nixos.org/t/replace-npm-deps-with-nix-deps/66394/3
  # - Then, makeWrapperArgs can't be used (not a script here but a library) so we manually set PLAYWRIGHT_BROWSERS_PATH
  # to forward the path to browser binaries
  postInstall = ''
    rm -rf node_modules/playwright
    ln -s ${playwright-driver} node_modules/playwright
    cp -r node_modules $out/lib
    cat >> $out/lib/python3.13/site-packages/Browser/__init__.py <<EOF
    import os
    if not "PLAYWRIGHT_BROWSERS_PATH" in os.environ:
        os.environ["PLAYWRIGHT_BROWSERS_PATH"] = "${playwright-driver.browsers}"
    if not "PLAYWRIGHT_SKIP_VALIDATE_HOST_REQUIREMENTS" in os.environ:
        os.environ["PLAYWRIGHT_SKIP_VALIDATE_HOST_REQUIREMENTS"] = "true"
    EOF
  '';

  meta = {
    description = "Robot Framework Browser library powered by Playwright";
    homepage = "https://robotframework-browser.org/";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ tobiasBora ];
  };

}
