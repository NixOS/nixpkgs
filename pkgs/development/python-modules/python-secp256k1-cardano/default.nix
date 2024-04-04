{ lib
, fetchFromGitHub
, python3
, pkg-config
}:

python3.pkgs.buildPythonPackage {
  pname = "python-secp256k1-cardano";
  version = "0.2.3";

  format = "setuptools";

  src = fetchFromGitHub {
    owner = "OpShin";
    repo = "python-secp256k1";
    rev = "5a8f761a4b9a1594653cc4deebadc3398b07533c"; # No tags in repo
    hash = "sha256-6bE4/G2gW2F8h5FWtI3TZ6FtijsB/slvFT/SIVv7VIY=";
  };

  nativeBuildInputs = [ pkg-config ];

  propagatedBuildInputs = with python3.pkgs; [ cffi secp256k1 ];

  nativeCheckInputs = [ python3.pkgs.pytestCheckHook ];

  # Tests expect .so files and are failing
  doCheck = false;

  preConfigure = ''
    cp -r ${python3.pkgs.secp256k1.src} libsecp256k1
    export INCLUDE_DIR=${python3.pkgs.secp256k1}/include
    export LIB_DIR=${python3.pkgs.secp256k1}/lib
  '';

  meta = {
    homepage = "https://github.com/OpShin/python-secp256k1";
    description = "A fork of python-secp256k1, fixing the commit hash of libsecp256k1 to a Cardano compatible version";
    license = with lib.licenses; [ mit ];
    maintainers = with lib.maintainers; [ t4ccer ];
  };
}
