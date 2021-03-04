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
  version = "0.31.1";

  src = fetchFromGitHub {
    owner = "etesync";
    repo = "etebase-py";
    rev = "v${version}";
    sha256 = "163iw64l8lwawf84qswcjsq9p8qddv9ysjrr3dzqpqxb2yb0sy39";
  };

  cargoDeps = rustPlatform.fetchCargoTarball {
    inherit src;
    name = "${pname}-${version}";
    sha256 = "0w8ypl6kj1mf6ahbdiwbd4jw6ldxdaig47zwk91jjsww5lbyx4lf";
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
    homepage = "https://www.etebase.com/";
    description = "A Python client library for Etebase";
    license = licenses.bsd3;
    maintainers = with maintainers; [ _3699n ];
  };
}
