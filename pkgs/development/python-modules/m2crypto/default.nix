{ stdenv
, buildPythonPackage
, fetchPypi
, pkgs
}:


buildPythonPackage rec {
  version = "0.24.0";
  pname = "M2Crypto";

  src = fetchPypi {
    inherit pname version;
    sha256 = "1s2y0pf2zg7xf4nfwrw7zhwbk615r5a7bgi5wwkwzh6jl50n99c0";
  };

  buildInputs = [ pkgs.swig2 pkgs.openssl ];

  preConfigure = ''
    substituteInPlace setup.py --replace "self.openssl = '/usr'" "self.openssl = '${pkgs.openssl.dev}'"
  '';

  doCheck = false; # another test that depends on the network.

  meta = with stdenv.lib; {
    description = "A Python crypto and SSL toolkit";
    homepage = http://chandlerproject.org/Projects/MeTooCrypto;
    license = licenses.mit;
  };

}
