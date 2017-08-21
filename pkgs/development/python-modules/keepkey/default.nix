{ stdenv, fetchPypi, buildPythonPackage, ecdsa
, mnemonic, protobuf3_2, hidapi }:

buildPythonPackage rec {
  name = "${pname}-${version}";
  pname = "keepkey";
  version = "0.7.3";

  src = fetchPypi {
    inherit pname version;
    sha256 = "14d2r8dlx997ypgma2k8by90acw7i3l7hfq4gar9lcka0lqfj714";
  };

  propagatedBuildInputs = [ protobuf3_2 hidapi ];

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
