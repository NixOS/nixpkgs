{ lib, buildPythonPackage, fetchPypi, cryptography, python-axolotl-curve25519, protobuf }:

buildPythonPackage rec {
  pname = "python-axolotl";
  version = "0.2.3";
  format = "setuptools";

  src = fetchPypi {
    inherit pname version;
    sha256 = "1bwdp24fmriffwx91aigs9k162albb51iskp23nc939z893q23py";
  };

  propagatedBuildInputs = [ cryptography python-axolotl-curve25519 protobuf ];

  meta = with lib; {
    homepage = "https://github.com/tgalal/python-axolotl";
    description = "Python port of libaxolotl-android";
    maintainers = with maintainers; [ abbradar ];
    license = licenses.gpl3;
  };
}
