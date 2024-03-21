{ lib
, buildPythonPackage
, fetchFromGitHub
, pythonOlder
  # nativeBuildInputs
, pythonRelaxDepsHook
, setuptools
  # nativeCheckInputs
, pytestCheckHook
  # install_requires
, appdirs
, beautifulsoup4
, cachecontrol
, distro
, feedparser
, lockfile
, packaging
, python-dateutil
, pyyaml
, requests
, tqdm
, urllib3
  # test_requires
, pytest
, flake8
, flake8-bugbear
, pytest-xdist
, pytest-cov
  # doc_requires
, mkdocs
, mkdocs-material
, mkdocstrings
, mkdocstrings-python
}:
let
  self = buildPythonPackage rec {
    pname = "lastversion";
    version = "3.5.0";
    pyproject = true;

    disabled = pythonOlder "3.6";

    src = fetchFromGitHub {
      owner = "dvershinin";
      repo = "lastversion";
      rev = "v${version}";
      hash = "sha256-SeDLpMP8cF6CC3qJ6V8dLErl6ihpnl4lHeBkp7jtQgI=";
    };

    nativeBuildInputs = [
      pythonRelaxDepsHook
      setuptools
    ];

    propagatedBuildInputs = [
      appdirs
      beautifulsoup4
      cachecontrol
      cachecontrol.optional-dependencies.filecache
      distro
      feedparser
      packaging
      python-dateutil
      pyyaml
      requests
      tqdm
      urllib3
    ];

    pythonImportsCheck = [ "lastversion" ];

    pythonRelaxDeps = [
      # install_requires
      "cachecontrol" # Use newer cachecontrol that uses filelock instead of lockfile
      "urllib3" # The cachecontrol and requests incompatibility issue is closed
      # tests_requires
      "pytest-xdist" # The upstream issue is closed
      # docs_requires
      "mkdocs"
      "mkdors-material"
    ];

    pythonRemoveDeps = [
      "lockfile" # "cachecontrol" now uses filelock instead
    ];

    passthru = {
      optional-dependencies = {
        docs = [
          mkdocs
          mkdocs-material
          mkdocstrings
          mkdocstrings-python
        ];
        # Not going to test here, as the tests require internet connection.
        tests = [
          pytest
          flake8
          flake8-bugbear
          pytest-xdist
          pytest-cov
        ];
      };
    };

    meta = with lib; {
      description = "Find the latest release version of an arbitrary project";
      homepage = "https://github.com/dvershinin/lastversion";
      changelog = "https://github.com/dvershinin/lastversion/blob/master/CHANGELOG.md";
      license = licenses.bsd2;
      maintainers = with maintainers; [ ShamrockLee ];
      mainProgram = "lastversion";
    };
  };
in
self
