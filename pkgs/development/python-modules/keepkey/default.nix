{ stdenv, fetchPypi, buildPythonPackage, ecdsa
, mnemonic, protobuf, hidapi }:

buildPythonPackage rec {
  name = "${pname}-${version}";
  pname = "keepkey";
  version = "4.0.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "95c8d5127919f9fc4bb0120b05f92efc8f526d4a68122ac18e63509571ac45a2";
  };

  propagatedBuildInputs = [ protobuf hidapi ];

  buildInputs = [ ecdsa mnemonic ];

  # There are no actual tests: "ImportError: No module named tests"
  doCheck = false;

  # Remove impossible dependency constraint
  postPatch = "sed -i -e 's|hidapi==|hidapi>=|' setup.py";

  meta = with stdenv.lib; {
    description = "KeepKey Python client";
    homepage = https://github.com/keepkey/python-keepkey;
    license = licenses.gpl3;
    maintainers = with maintainers; [ np ];
  };
}
