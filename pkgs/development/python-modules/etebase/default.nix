{ lib, stdenv
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
, Security
}:

rustPlatform.buildRustPackage rec {
  pname = "etebase";
  version = "0.31.1";

  src = fetchFromGitHub {
    owner = "etesync";
    repo = "etebase-py";
    rev = "v${version}";
    sha256 = "163iw64l8lwawf84qswcjsq9p8qddv9ysjrr3dzqpqxb2yb0sy39";
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

  buildInputs = lib.optionals stdenv.isDarwin [ Security ];

  propagatedBuildInputs = [
    python
    msgpack
  ];

  doCheck = true;

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
