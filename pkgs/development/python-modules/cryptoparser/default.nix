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
  version = "0.12.0";
  format = "pyproject";

  src = fetchPypi {
    pname = "CryptoParser";
    inherit version;
    hash = "sha256-E32fHcuICUMCH5NYT+oFYU7M73bvXb/g1UoJSChzOiA=";
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
