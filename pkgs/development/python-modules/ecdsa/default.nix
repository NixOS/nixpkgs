{ lib
, buildPythonPackage
, fetchPypi
, pkgs
, six
}:

buildPythonPackage rec {
  pname = "ecdsa";
  version = "0.18.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-GQNIBBVZ4hsiodZc7khSgsoRpvgdUD/duE1QF+ntHkk=";
  };

  propagatedBuildInputs = [ six ];
  # Only needed for tests
  nativeCheckInputs = [ pkgs.openssl ];

  meta = with lib; {
    description = "ECDSA cryptographic signature library";
    homepage = "https://github.com/warner/python-ecdsa";
    license = licenses.mit;
  };

}
