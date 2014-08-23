{ stdenv, fetchurl, buildPythonPackage, openssl }:

buildPythonPackage rec {
  name = "ecdsa-0.11";

  src = fetchurl {
    url = "https://pypi.python.org/packages/source/e/ecdsa/${name}.tar.gz";
    sha256 = "134mbq5xsvx54k9xm7zrizvh9imxmcz1w9mhyfr99p4i7wcnqfwf";
  };

  buildInputs = [ openssl ];

  meta = {
    homepage = "http://github.com/warner/python-ecdsa";
    description = "pure-python ECDSA signature/verification";
    license = stdenv.lib.licenses.mit;
  };
}