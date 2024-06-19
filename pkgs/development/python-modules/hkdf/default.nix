{
  lib,
  buildPythonPackage,
  fetchPypi,
  nose,
}:

buildPythonPackage rec {
  pname = "hkdf";
  version = "0.0.3";
  format = "setuptools";

  src = fetchPypi {
    inherit pname version;
    sha256 = "1jhxk5vhxmxxjp3zj526ry521v9inzzl8jqaaf0ma65w6k332ak2";
  };

  nativeCheckInputs = [ nose ];

  checkPhase = ''
    nosetests
  '';

  # no tests in PyPI tarball
  doCheck = false;

  meta = with lib; {
    description = "HMAC-based Extract-and-Expand Key Derivation Function (HKDF)";
    homepage = "https://github.com/casebeer/python-hkdf";
    license = licenses.bsd2;
  };
}
