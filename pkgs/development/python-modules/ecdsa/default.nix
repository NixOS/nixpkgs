{ stdenv
, buildPythonPackage
, fetchPypi
, pkgs
, six
}:

buildPythonPackage rec {
  pname = "ecdsa";
  version = "0.14.1";

  src = fetchPypi {
    inherit pname version;
    sha256 = "64c613005f13efec6541bb0a33290d0d03c27abab5f15fbab20fb0ee162bdd8e";
  };

  propagatedBuildInputs = [ six ];
  # Only needed for tests
  checkInputs = [ pkgs.openssl ];

  meta = with stdenv.lib; {
    description = "ECDSA cryptographic signature library";
    homepage = "https://github.com/warner/python-ecdsa";
    license = licenses.mit;
    maintainers = with maintainers; [ aszlig ];
  };

}
