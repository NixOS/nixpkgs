{ lib
, buildPythonPackage
, dissect-cstruct
, dissect-util
, fetchFromGitHub
, pycryptodome
, pytestCheckHook
, pythonOlder
, rich
, setuptools
, setuptools-scm
}:

buildPythonPackage rec {
  pname = "dissect-hypervisor";
  version = "3.8";
  format = "pyproject";

  disabled = pythonOlder "3.8";

  src = fetchFromGitHub {
    owner = "fox-it";
    repo = "dissect.hypervisor";
    rev = "refs/tags/${version}";
    hash = "sha256-PTF1PSFsjD9lYa3SLd7329+ZZuSC07tN1GqwOndo8Go=";
  };

  SETUPTOOLS_SCM_PRETEND_VERSION = version;

  nativeBuildInputs = [
    setuptools
    setuptools-scm
  ];

  propagatedBuildInputs = [
    dissect-cstruct
    dissect-util
  ];

  passthru.optional-dependencies = {
    full = [
      pycryptodome
      rich
    ];
  };

  nativeCheckInputs = [
    pytestCheckHook
  ];

  pythonImportsCheck = [
    "dissect.hypervisor"
  ];

  meta = with lib; {
    description = "Dissect module implementing parsers for various hypervisor disk, backup and configuration files";
    homepage = "https://github.com/fox-it/dissect.hypervisor";
    changelog = "https://github.com/fox-it/dissect.hypervisor/releases/tag/${version}";
    license = licenses.agpl3Only;
    maintainers = with maintainers; [ fab ];
  };
}
