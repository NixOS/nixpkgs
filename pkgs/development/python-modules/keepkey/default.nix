{ stdenv, fetchFromGitHub, buildPythonPackage, pytest
, ecdsa , mnemonic, protobuf, hidapi, trezor }:

buildPythonPackage rec {
  name = "${pname}-${version}";
  pname = "keepkey";
  version = "4.0.0";

  src = fetchFromGitHub {
    owner = "keepkey";
    repo = "python-keepkey";
    rev = "v${version}";
    sha256 = "144awjkc169z2n1ffirs697y6m97izh3pbh3sjhy3nji7jszh592";
  };

  propagatedBuildInputs = [ protobuf hidapi trezor ];

  buildInputs = [ ecdsa mnemonic ];

  checkInputs = [ pytest ];

  # tests requires hardware
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
