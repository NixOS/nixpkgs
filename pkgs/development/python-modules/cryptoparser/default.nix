{ lib
, buildPythonPackage
, fetchPypi
, setuptools
, attrs
, asn1crypto
, cryptodatahub
, python-dateutil
, urllib3
, pytestCheckHook
}:

buildPythonPackage rec {
  pname = "cryptoparser";
  version = "0.12.3";
  pyproject = true;

  src = fetchPypi {
    pname = "CryptoParser";
    inherit version;
    hash = "sha256-1A0VEpUPsYtEu2aT+ldt/Z/PtV8lvD+9jSx75yGB6Ao=";
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
    cryptodatahub
    python-dateutil
    urllib3
  ];

  pythonImportsCheck = [
    "cryptoparser"
  ];

  meta = with lib; {
    description = "Security protocol parser and generator";
    homepage = "https://gitlab.com/coroner/cryptoparser";
    changelog = "https://gitlab.com/coroner/cryptoparser/-/blob/v${version}/CHANGELOG.md";
    license = licenses.mpl20;
    maintainers = with maintainers; [ kranzes ];
  };
}
