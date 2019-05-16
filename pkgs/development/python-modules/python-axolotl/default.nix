{ lib, buildPythonPackage, fetchPypi, cryptography, python-axolotl-curve25519, protobuf }:

buildPythonPackage rec {
  pname = "python-axolotl";
  version = "0.2.2";

  src = fetchPypi {
    inherit pname version;
    sha256 = "1had4dq4n26c3hp62rbmhvs1dj3j3z2jhcbddnbsmqmiky8dqs39";
  };

  propagatedBuildInputs = [ cryptography python-axolotl-curve25519 protobuf ];

  meta = with lib; {
    homepage = https://github.com/tgalal/python-axolotl;
    description = "Python port of libaxolotl-android";
    maintainers = with maintainers; [ abbradar ];
    license = licenses.gpl3;
  };
}
