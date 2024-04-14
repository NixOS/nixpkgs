{ lib
, buildPythonPackage
, fetchFromGitHub
, nix-update-script
, overrides
, pydantic_1
, pydantic-yaml-0
, pyxdg
, pyyaml
, requests
, requests-unixsocket
, types-pyyaml
, urllib3
, pytestCheckHook
, pytest-check
, pytest-mock
, pytest-subprocess
, requests-mock
, hypothesis
, git
, squashfsTools
, setuptools
, setuptools-scm
}:

buildPythonPackage rec {
  pname = "craft-parts";
  version = "1.29.0";

  pyproject = true;

  src = fetchFromGitHub {
    owner = "canonical";
    repo = "craft-parts";
    rev = "refs/tags/${version}";
    hash = "sha256-3AWiuRGUGj6q6ZEnShc64DSL1S6kTsry4Z1IYMelvzg=";
  };

  patches = [
    ./bash-path.patch
  ];

  postPatch = ''
    substituteInPlace setup.py \
      --replace-fail "pydantic-yaml[pyyaml]>=0.11.0,<1.0.0" "pydantic-yaml[pyyaml]" \
      --replace-fail "urllib3<2" "urllib3"
  '';

  nativeBuildInputs = [
    setuptools
    setuptools-scm
  ];

  propagatedBuildInputs = [
    overrides
    pydantic_1
    pydantic-yaml-0
    pyxdg
    pyyaml
    requests
    requests-unixsocket
    types-pyyaml
    urllib3
  ];

  pythonImportsCheck = [
    "craft_parts"
  ];

  nativeCheckInputs = [
    git
    hypothesis
    pytest-check
    pytest-mock
    pytest-subprocess
    pytestCheckHook
    requests-mock
    squashfsTools
  ];

  pytestFlagsArray = [ "tests/unit" ];

  preCheck = ''
    export HOME=$(mktemp -d)
  '';

  disabledTests = [
    # Relies upon paths not present in Nix (like /bin/bash)
    "test_run_builtin_build"
    "test_run_prime"
    "test_get_build_packages_with_source_type"
    "test_get_build_packages"
  ];

  disabledTestPaths = [
    # Relies upon filesystem extended attributes, and suid/guid bits
    "tests/unit/sources/test_base.py"
    "tests/unit/packages/test_base.py"
    "tests/unit/state_manager"
    "tests/unit/test_xattrs.py"
    "tests/unit/packages/test_normalize.py"
    # Relies upon presence of apt/dpkg.
    "tests/unit/packages/test_apt_cache.py"
    "tests/unit/packages/test_deb.py"
    "tests/unit/packages/test_chisel.py"
  ];

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Software artifact parts builder from Canonical";
    homepage = "https://github.com/canonical/craft-parts";
    changelog = "https://github.com/canonical/craft-parts/releases/tag/${version}";
    license = lib.licenses.lgpl3Only;
    maintainers = with lib.maintainers; [ jnsgruk ];
    platforms = lib.platforms.linux;
  };
}

