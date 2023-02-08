{ lib
, buildNpmPackage
, buildPythonPackage
, fetchFromGitHub
, pythonOlder

# build
, colorama
, setuptools

# runtime
, contourpy
, jinja2
, nodejs
, numpy
, packaging
, pandas
, pillow
, pyyaml
, tornado
, xyzservices

# tests
, beautifulsoup4
, git
, json5
, nbconvert
, pytest-asyncio
, pytest-html
, pytest-rerunfailures
, pytest-xdist
, pytestCheckHook
, requests
, requests-unixsocket
, selenium
}:

let
  # update together with panel, which is not straightforward
  version = "3.2.0";

  src = fetchFromGitHub {
    owner = "bokeh";
    repo = "bokeh";
    rev = "refs/tags/${version}";
    hash = "sha256-YgmGpMtIeuEHkWg7tx4ItBOQfdsVripXg+Aa3+KdsAA=";
  };

  bokehjs = buildNpmPackage {
    pname = "bokehjs";
    inherit version;

    inherit src;
    sourceRoot = "source/bokehjs";

    npmDepsHash = "sha256-hUoofSZkFY/h5UoPVldYiQW8OtQ8W786ZUgpmIwTdeI=";

    preInstall = ''
      # install files that are in the upstream tarball but not covered
      # by the `files` definition in package.json
      # Has to happen in preInstall, because pruning happens during
      # installPhase.
      PREFIX=$out/lib/node_modules/@bokeh/bokehjs/build
      mkdir -p $PREFIX/{js,lib}

      cp -R ./node_modules/typescript/lib/lib.*.ts $PREFIX/lib/
      cp ./build/js/{bokeh.json,compiler.js} $PREFIX/js/
      cp -R ./build/js/compiler $PREFIX/js/
    '';
  };
in
buildPythonPackage rec {
  pname = "bokeh";
  inherit version;
  format = "pyproject";

  disabled = pythonOlder "3.9";

  inherit src;

  nativeBuildInputs = [
    colorama
    setuptools
  ];

  postPatch = ''
    # workaround for setuptools-git-versioning not supporting overrides
    # https://github.com/dolfinus/setuptools-git-versioning/issues/77
    substituteInPlace pyproject.toml \
      --replace 'dynamic = ["version"]' 'version = "${version}"'

    # inject fully built artifacts
    rm -r src/bokeh/server/static
    ln -s "${bokehjs}/lib/node_modules/@bokeh/bokehjs/build" "src/bokeh/server/static"
    touch PKG-INFO
  '';

  propagatedBuildInputs = [
    contourpy
    jinja2
    numpy
    packaging
    pandas
    pillow
    pyyaml
    tornado
    xyzservices
  ];

  pythonImportsCheck = [
    "bokeh"
  ];

  nativeCheckInputs = [
    beautifulsoup4
    git
    json5
    nbconvert
    nodejs
    pytest-asyncio
    pytest-html
    pytest-rerunfailures
    pytest-xdist
    pytestCheckHook
    requests
    requests-unixsocket
    selenium
  ];

  dontUsePytestXdist = true;

  __darwinAllowLocalNetworking = true;

  pytestFlagsArray = [
    # sampledata needs to be downloaded, selenium tests are brittle
    "-m" "'not sampledata and not selenium'"
    # limit parallelism, so we don't run into socket bind conflicts
    "--numprocesses=$(( $NIX_BUILD_CORES > 4 ? 4 : $NIX_BUILD_CORES ))"
    # give some tests more chances to complete
    "--reruns=3"
  ];

  disabledTestPaths = [
    # tries to fetch node modules
    "tests/test_bokehjs.py"
    # expects to be executed in a git repository
    "tests/test_defaults.py"
    # fails to find examples
    "tests/test_examples.py"
    # linters
    "tests/codebase"
    # ignore selenium tests, not all are marked apparently
    "tests/unit/bokeh/io/test_webdriver.py"
  ];

  disabledTests = [
    # assert filename and filename.endswith(("py.test", "pytest", "py.test-script.py", "pytest-script.py"))
    # assert (None)
    "test_detect_current_filename"
    # tries to fetch node modules
    "test_ext_commands"
    # AssertionError: assert [{'extends': ...rop3'}], ...}] == [{'name': 'te...ro...
    "test_serialization_data_models"
    # Failed: Did not find pattern in process output
    "test_websocket_max_message_size_printed_out"
    # FileNotFoundError: [Errno 2] No such file or directory: '/build/source/tests/unit/bokeh/embed/latex_label/dist/latex_label.js
    # FileNotFoundError: [Errno 2] No such file or directory: '/build/source/tests/unit/bokeh/embed/ext_package_no_main/dist/ext_package_no_main.js'
    "test_with_CDN_resources"
    "test_with_INLINE_resources"
  ];

  passthru = {
    inherit bokehjs;
  };

  meta = with lib; {
    description = "Statistical and novel interactive HTML plots for Python";
    homepage = "https://github.com/bokeh/bokeh";
    changelog = "https://docs.bokeh.org/en/latest/docs/releases.html#release-${replaceStrings ["."] ["-"] version}";
    license = licenses.bsd3;
    maintainers = with maintainers; [ orivej ];
  };
}
