{
  lib,
  stdenv,
  buildPythonPackage,
  fetchFromGitHub,
  writeText,
  nodejs,
  yarn-berry_3,
  jupyterlab,
  jupyter-packaging,
  bqscales,
  ipywidgets,
  numpy,
  pandas,
  traitlets,
  traittypes,
  pytestCheckHook,
}:

let
  version = "0.13.1";

  src = fetchFromGitHub {
    owner = "bqplot";
    repo = "bqplot";
    tag = version;
    hash = "sha256-mYeQzmUa7WFDL8o6xsRD2bZ+3E9y4K/KyGE0zr0V4BA=";
  };

  frontend = stdenv.mkDerivation {
    pname = "bqplot-frontend";
    inherit version src;

    sourceRoot = "${src.name}/js";

    # no hashes are missing
    missingHashes = writeText "missing-hashes.json" /* json */ ''
      {}
    '';

    yarnOfflineCache = yarn-berry_3.fetchYarnBerryDeps {
      inherit src;
      yarnLock = "js/yarn.lock";
      hash = "sha256-g7G+NsVDxWZ9wM0TrJC2ew28rUKQUFL5MMcQVWpe9jo=";
    };

    postPatch = ''
      substituteInPlace package.json \
        --replace-fail "jlpm run" "yarn run"

      substituteInPlace package.json webpack.config.js \
        --replace-fail "../share/jupyter" "share/jupyter"
    '';

    nativeBuildInputs = [
      nodejs
      yarn-berry_3
      yarn-berry_3.yarnBerryConfigHook
      jupyterlab
    ];

    buildPhase = ''
      runHook preBuild

      yarn run build

      runHook postBuild
    '';

    installPhase = ''
      runHook preInstall

      mkdir -p $out
      cp -r share $out/share

      runHook postInstall
    '';
  };
in
buildPythonPackage {
  inherit version src;
  pname = "bqplot";
  pyproject = true;

  preBuild = ''
    cp -r ${frontend}/share ./share
  '';

  build-system = [
    jupyter-packaging
    jupyterlab
  ];

  dependencies = [
    bqscales
    ipywidgets
    numpy
    pandas
    traitlets
    traittypes
  ];

  nativeCheckInputs = [
    pytestCheckHook
  ];

  # clear upstreams `addopts = --nbval --current-env`
  pytestFlags = [
    "-o"
    "addopts="
  ];
  enabledTestPaths = [ "tests/" ];

  pythonImportsCheck = [
    "bqplot"
    "bqplot.pyplot"
  ];

  meta = {
    description = "2D plotting library for Jupyter based on Grammar of Graphics";
    homepage = "https://bqplot.github.io/bqplot";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ bcdarwin ];
  };
}
