{
  lib,
  asn1crypto,
  attrs,
  buildPythonPackage,
  cryptodatahub,
  fetchPypi,
  python-dateutil,
  pythonOlder,
  setuptools,
  urllib3,
}:

buildPythonPackage rec {
  pname = "cryptoparser";
  version = "0.12.5";
  pyproject = true;

  disabled = pythonOlder "3.7";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-t8vK7T6nz1iH81fTMEYkQv7E7EjmkTx3u4zUIybEm5E=";
  };

  postPatch = ''
    substituteInPlace requirements.txt  \
      --replace-fail "attrs>=20.3.0,<22.0.1" "attrs>=20.3.0"
  '';

  build-system = [ setuptools ];

  dependencies = [
    asn1crypto
    attrs
    cryptodatahub
    python-dateutil
    urllib3
  ];

  pythonImportsCheck = [ "cryptoparser" ];

  meta = with lib; {
    description = "Security protocol parser and generator";
    homepage = "https://gitlab.com/coroner/cryptoparser";
    changelog = "https://gitlab.com/coroner/cryptoparser/-/blob/v${version}/CHANGELOG.md";
    license = licenses.mpl20;
    maintainers = with maintainers; [ kranzes ];
  };
}
