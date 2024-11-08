{
  lib,
  fetchFromGitHub,
  buildPythonPackage,
  ecdsa,
  hidapi,
  libusb1,
  mnemonic,
  protobuf,
  pytest,
}:

buildPythonPackage rec {
  pname = "keepkey";
  version = "7.2.1";
  format = "setuptools";

  src = fetchFromGitHub {
    owner = "keepkey";
    repo = "python-keepkey";
    rev = "v${version}";
    sha256 = "00hqppdj3s9y25x4ad59y8axq94dd4chhw9zixq32sdrd9v8z55a";
  };

  propagatedBuildInputs = [
    ecdsa
    hidapi
    libusb1
    mnemonic
    protobuf
  ];

  nativeCheckInputs = [ pytest ];

  # tests requires hardware
  doCheck = false;

  # Remove impossible dependency constraint
  postPatch = "sed -i -e 's|hidapi==|hidapi>=|' setup.py";

  meta = with lib; {
    description = "KeepKey Python client";
    mainProgram = "keepkeyctl";
    homepage = "https://github.com/keepkey/python-keepkey";
    license = licenses.gpl3;
    maintainers = with maintainers; [ np ];
  };
}
