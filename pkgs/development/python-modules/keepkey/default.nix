{ stdenv, fetchFromGitHub, buildPythonPackage, pytest
, ecdsa , mnemonic, protobuf, hidapi, trezor }:

buildPythonPackage rec {
  pname = "keepkey";
  version = "6.6.0";

  src = fetchFromGitHub {
    owner = "keepkey";
    repo = "python-keepkey";
    rev = "v${version}";
    sha256 = "1v0ns26ykskn0dpbvz9g6lz4q740qmahvddj3pc3rfbjvg43p3vh";
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
    homepage = "https://github.com/keepkey/python-keepkey";
    license = licenses.gpl3;
    maintainers = with maintainers; [ np ];
  };
}
