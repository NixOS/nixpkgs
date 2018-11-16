{ stdenv, fetchFromGitHub, buildPythonPackage, pytest
, ecdsa , mnemonic, protobuf, hidapi, trezor }:

buildPythonPackage rec {
  pname = "keepkey";
  version = "4.0.2";

  src = fetchFromGitHub {
    owner = "keepkey";
    repo = "python-keepkey";
    rev = "v${version}";
    sha256 = "0aa7j9b4f9gz198j8svxdrffwva1ai8vc55v6xbb2a3lfzmpsf9n";
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
