{ lib
, stdenvNoCC
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
, markdown-include
, mkdocs
, mkdocs-material
, mkdocstrings
, mkdocstrings-python
, pymdown-extensions
}:

(buildPythonPackage rec {
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
    distro
    feedparser
    packaging
    python-dateutil
    pyyaml
    requests
    tqdm
    urllib3
  ] ++ cachecontrol.optional-dependencies.filecache;

  pythonImportsCheck = [ "lastversion" ];

  pythonRelaxDeps = [
    "cachecontrol" # Use newer cachecontrol that uses filelock instead of lockfile
    "urllib3" # The cachecontrol and requests incompatibility issue is closed
    "pytest-xdist" # The upstream issue is closed
    "mkdocs"
    "mkdocs-material"
  ];

  pythonRemoveDeps = [
    "lockfile" # "cachecontrol" now uses filelock
  ];

  passthru = {
    optional-dependencies = {
      docs = [
        markdown-include
        mkdocs
        mkdocs-material
        mkdocstrings
        mkdocstrings-python
        pymdown-extensions
      ];
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
    changelog = "https://github.com/dvershinin/lastversion/blob/${src.rev}/CHANGELOG.md";
    license = licenses.bsd2;
    maintainers = with maintainers; [ ShamrockLee ];
    mainProgram = "lastversion";
  };

}).overrideAttrs (finalAttrs: previousAttrs: {
  passthru = previousAttrs.passthru // {
    tests = {
      pytest-cli-format = finalAttrs.finalPackage.overridePythonAttrs (previousPythonAttrs: {
        doCheck = true;

        nativeCheckInputs = [
          pytestCheckHook
        ];

        checkInputs = finalAttrs.passthru.optional-dependencies.tests;

        pytestFlagsArray = [
          "tests/test_cli.py"
          "-k"
          "test_cli_format"
        ];

        # CLI tests expect the output bin/ in PATH
        preCheck = previousPythonAttrs.preCheck or "" + ''
          PATH="$out/bin:$PATH"
        '';
      });

      doc = stdenvNoCC.mkDerivation {
        pname = "lastversion-doc";
        inherit (finalAttrs) version src;

        nativeBuildInputs = finalAttrs.passthru.optional-dependencies.docs;

        # See https://github.com/dvershinin/lastversion/blob/master/.readthedocs-custom-steps.yml
        postPatch = ''
          substituteInPlace README-ZH-CN.md \
            --replace-fail README.md index.md
        '';
        buildPhase = ''
          runHook preBuild
          mkdocs build
          runHook postBuild
        '';
        installPhase = ''
          runHook preInstall
          mkdir -p "$out/share/doc/lastversion"
          mv site "$out/share/doc/lastversion"
          runHook postInstall
        '';
      };
    };
  };
})
