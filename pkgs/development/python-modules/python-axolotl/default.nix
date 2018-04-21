{ lib, buildPythonPackage, fetchurl, python-axolotl-curve25519, protobuf, pycrypto }:

buildPythonPackage rec {
  name = "python-axolotl-${version}";
  version = "0.1.39";

  src = fetchurl {
    url = "mirror://pypi/p/python-axolotl/${name}.tar.gz";
    sha256 = "09bf5gfip9x2wr0ij43p39ac6z2iqzn7kgpi2jjbwpnhs0vwkycs";
  };

  propagatedBuildInputs = [ python-axolotl-curve25519 protobuf pycrypto ];
  # IV == 0 in tests is not supported by pycryptodome (our pycrypto drop-in)
  doCheck = false;

  meta = with lib; {
    homepage = https://github.com/tgalal/python-axolotl;
    description = "Python port of libaxolotl-android";
    maintainers = with maintainers; [ abbradar ];
    license = licenses.gpl3;
  };
}
