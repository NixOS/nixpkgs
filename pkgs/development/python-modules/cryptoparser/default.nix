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
  version = "0.10.3";
  format = "pyproject";

  src = fetchPypi {
    pname = "CryptoParser";
    inherit version;
    hash = "sha256-FvSs0LeyuobkJhJd5vlR+Bm4LqGxPvPTogsYKtHOpVw=";
  };

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
