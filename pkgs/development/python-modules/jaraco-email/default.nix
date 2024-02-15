{ lib
, stdenv
, buildPythonPackage
, pythonOlder
, fetchFromGitHub
, fetchpatch
, setuptools
, setuptools-scm
, jaraco-text
, jaraco-collections
, keyring
, pytestCheckHook
}:

buildPythonPackage rec {
  pname = "jaraco-email";
  version = "3.1.0";

  disabled = pythonOlder "3.7";

  format = "pyproject";

  src = fetchFromGitHub {
    owner = "jaraco";
    repo = "jaraco.email";
    rev = "refs/tags/v${version}";
    hash = "sha256-MR/SX5jmZvEMULgvQbh0JBZjIosNCPWl1wvEoJbdw4Y=";
  };

  patches = [
    (fetchpatch {
      name = "dos2unix-line-endings.patch";
      url = "https://github.com/jaraco/jaraco.email/commit/ab9643598e26cca9c9cdbd34b00c972f547b9236.patch";
      hash = "sha256-Z2WOnR+ELzQciVyUiUq4jaP+Vnc4aseLP7+LWJZoOU8=";
    })
    (fetchpatch {
      name = "jaraco-collections-4-compatibility.patch";
      url = "https://github.com/jaraco/jaraco.email/commit/e65e5fed0178ddcd009d16883b381c5582f1a9df.patch";
      hash = "sha256-mKxa0ZU1JFeQPemrjQl94buLNY5gXnMCCRKBxdO870M=";
    })
  ];

  nativeBuildInputs = [
    setuptools
    setuptools-scm
  ];

  propagatedBuildInputs = [
    jaraco-text
    jaraco-collections
    keyring
  ];

  pythonImportsCheck = [ "jaraco.email" ];

  nativeCheckInputs = [
    pytestCheckHook
  ];

  meta = {
    changelog = "https://github.com/jaraco/jaraco.email/blob/${src.rev}/CHANGES.rst";
    description = "E-mail facilities by jaraco";
    homepage = "https://github.com/jaraco/jaraco.email";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ dotlambda ];
  };
}
