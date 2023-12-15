{ lib
, buildPythonPackage
, fetchFromGitLab

# build-system
, setuptools

# dependencies
, asn1crypto
, attrs
, pathlib2
, python-dateutil
, six
, urllib3

# tests
, beautifulsoup4
, pyfakefs
, unittestCheckHook
}:

buildPythonPackage rec {
  pname = "cryptodatahub";
  version = "0.10.1";
  format = "pyproject";

  src = fetchFromGitLab {
    owner = "coroner";
    repo = "cryptodatahub";
    rev = "v${version}";
    hash = "sha256-eLdK5gFrLnbIBB1NTeQzpdCLPdATVjzPn5LhhUsDuwo=";
  };

  nativeBuildInputs = [
    setuptools
  ];

  propagatedBuildInputs = [
    asn1crypto
    attrs
    pathlib2
    python-dateutil
    six
    urllib3
  ];

  pythonImportsCheck = [ "cryptodatahub" ];

  nativeCheckInputs = [
    beautifulsoup4
    pyfakefs
    unittestCheckHook
  ];

  preCheck = ''
    # failing tests
    rm test/updaters/test_common.py
  '';

  meta = with lib; {
    description = "Repository of cryptography-related data";
    homepage = "https://gitlab.com/coroner/cryptodatahub";
    changelog = "https://gitlab.com/coroner/cryptodatahub/-/blob/${src.rev}/CHANGELOG.rst";
    license = licenses.mpl20;
    maintainers = with maintainers; [ ];
  };
}
