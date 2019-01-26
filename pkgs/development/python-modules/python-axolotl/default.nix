{ lib, buildPythonPackage, fetchPypi, cryptography, python-axolotl-curve25519, protobuf }:

buildPythonPackage rec {
  pname = "python-axolotl";
  version = "0.1.42";

  src = fetchPypi {
    inherit pname version;
    sha256 = "ef78c2efabcd4c33741669334bdda04710a3ef0e00b653f00127acff6460a7f0";
  };

  propagatedBuildInputs = [ cryptography python-axolotl-curve25519 protobuf ];

  meta = with lib; {
    homepage = https://github.com/tgalal/python-axolotl;
    description = "Python port of libaxolotl-android";
    maintainers = with maintainers; [ abbradar ];
    license = licenses.gpl3;
  };
}
