{ lib, fetchFromGitHub, buildPythonPackage, pytest
, ecdsa , mnemonic, protobuf, hidapi, trezor }:

buildPythonPackage rec {
  pname = "keepkey";
  version = "7.2.1";

  src = fetchFromGitHub {
    owner = "keepkey";
    repo = "python-keepkey";
    rev = "v${version}";
    sha256 = "00hqppdj3s9y25x4ad59y8axq94dd4chhw9zixq32sdrd9v8z55a";
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
