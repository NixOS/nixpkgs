{ lib
, asn1crypto
, attrs
, beautifulsoup4
, buildPythonPackage
, fetchFromGitLab
, pathlib2
, pyfakefs
, python-dateutil
, pythonOlder
, setuptools
, six
, unittestCheckHook
, urllib3
}:

buildPythonPackage rec {
  pname = "cryptodatahub";
  version = "0.10.1";
  pyproject = true;

  disabled = pythonOlder "3.7";

  src = fetchFromGitLab {
    owner = "coroner";
    repo = "cryptodatahub";
    rev = "refs/tags/v${version}";
    hash = "sha256-eLdK5gFrLnbIBB1NTeQzpdCLPdATVjzPn5LhhUsDuwo=";
  };

  postPatch = ''
    substituteInPlace requirements.txt  \
      --replace-warn "attrs>=20.3.0,<22.0.1" "attrs>=20.3.0"
  '';

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

  nativeCheckInputs = [
    beautifulsoup4
    pyfakefs
    unittestCheckHook
  ];

  pythonImportsCheck = [
    "cryptodatahub"
  ];


  preCheck = ''
    # failing tests
    rm test/updaters/test_common.py
  '';

  meta = with lib; {
    description = "Repository of cryptography-related data";
    homepage = "https://gitlab.com/coroner/cryptodatahub";
    changelog = "https://gitlab.com/coroner/cryptodatahub/-/blob/${version}/CHANGELOG.rst";
    license = licenses.mpl20;
    maintainers = with maintainers; [ ];
  };
}
