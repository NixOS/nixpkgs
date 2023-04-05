{ lib
, stdenv
, fetchFromGitHub
, buildPythonPackage
, rustPlatform
, pkg-config
, rustfmt
, setuptools-rust
, openssl
, Security
, msgpack
}:

buildPythonPackage rec {
  pname = "etebase";
  version = "0.31.6";

  src = fetchFromGitHub {
    owner = "etesync";
    repo = "etebase-py";
    rev = "v${version}";
    hash = "sha256-T61nPW3wjBRjmJ81w59T1b/Kxrwwqvyj3gILE9OF/5Q=";
  };

  cargoDeps = rustPlatform.fetchCargoTarball {
    inherit src;
    name = "${pname}-${version}";
    hash = "sha256-wrMNtcaLAsWBVeJbYbYo+Xmobl01lnUbR9NUqqUzUgU=";
  };

  format = "pyproject";

  nativeBuildInputs = [
    pkg-config
    rustfmt
    setuptools-rust
  ] ++ (with rustPlatform; [
    cargoSetupHook
    rust.cargo
    rust.rustc
  ]);

  buildInputs = [ openssl ] ++ lib.optionals stdenv.isDarwin [ Security ];

  propagatedBuildInputs = [
    msgpack
  ];

  postPatch = ''
    # Use system OpenSSL, which gets security updates.
    substituteInPlace Cargo.toml \
      --replace ', features = ["vendored"]' ""
  '';

  pythonImportsCheck = [ "etebase" ];


  meta = with lib; {
    broken = stdenv.isDarwin;
    homepage = "https://www.etebase.com/";
    description = "A Python client library for Etebase";
    license = licenses.bsd3;
    maintainers = with maintainers; [ _3699n ];
  };
}
