{ lib
, wheel
, rustPlatform
, pipInstallHook
, setuptools-rust
, python
, msgpack
, requests
, openssl
, perl
, rustfmt
, fetchFromGitHub
}:

rustPlatform.buildRustPackage rec {
  pname = "etebase";
  version = "0.31.1";

  src = fetchFromGitHub {
    owner = "etesync";
    repo = "etebase-py";
    rev = "950902a520417eaaf34d2c5e5e590ddb3c90358e";
    sha256 = "163iw64l8lwawf84qswcjsq9p8qddv9ysjrr3dzqpqxb2yb0sy39";
    fetchSubmodules = true;
  };


  cargoSha256 = "0w8ypl6kj1mf6ahbdiwbd4jw6ldxdaig47zwk91jjsww5lbyx4lf";

  nativeBuildInputs = [
    rustfmt
    perl
    openssl
    pipInstallHook
    setuptools-rust
    wheel
  ];

  propagatedBuildInputs = [
    python
    msgpack
  ];

  doCheck = false;
  doInstallCheck = true;

  buildPhase = ''
    ${python.interpreter} setup.py bdist_wheel
  '';

  installPhase = ''
    pipInstallPhase
  '';

  meta = with lib; {
    homepage = "https://www.etebase.com/";
    description = "A Python client library for Etebase";
    license = licenses.bsd3;
    maintainers = with maintainers; [ _3699n ];
  };

}
