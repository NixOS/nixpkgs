{ lib, fetchFromGitHub, buildPythonPackage, pytest
, ecdsa , mnemonic, protobuf, hidapi, trezor }:

buildPythonPackage rec {
  pname = "keepkey";
  version = "6.7.0";

  src = fetchFromGitHub {
    owner = "keepkey";
    repo = "python-keepkey";
    rev = "v${version}";
    sha256 = "0yi27wzb4q371y4bywi4hz37h4x63wjsyaa2mbx0rgc8xl2wm6yz";
  };

  propagatedBuildInputs = [ protobuf hidapi trezor ];

  buildInputs = [ ecdsa mnemonic ];

  checkInputs = [ pytest ];

  # tests requires hardware
  doCheck = false;

  # Remove impossible dependency constraint
  postPatch = "sed -i -e 's|hidapi==|hidapi>=|' setup.py";

  meta = with lib; {
    description = "KeepKey Python client";
    homepage = "https://github.com/keepkey/python-keepkey";
    license = licenses.gpl3;
    maintainers = with maintainers; [ np ];
  };
}
