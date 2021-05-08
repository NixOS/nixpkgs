{ lib
, stdenv
, fetchFromGitHub
, cmake
, openssl
, perl
, pkg-config
, rustPlatform
, sqlite
}:

stdenv.mkDerivation rec {
  pname = "libdeltachat";
  version = "1.54.0";

  src = fetchFromGitHub {
    owner = "deltachat";
    repo = "deltachat-core-rust";
    rev = version;
    sha256 = "02hvsfv1yar8bdpkfrfiiicq9qqnfhp46v6qqph9ar6khz3f1kim";
  };

  cargoDeps = rustPlatform.fetchCargoTarball {
    inherit src;
    name = "${pname}-${version}";
    sha256 = "1p5yrhczp9nfijbvkmkmx1rabk5k3c1ni4k1vc0mw4jgl26lslcm";
  };

  nativeBuildInputs = [
    cmake
    perl
    pkg-config
  ] ++ (with rustPlatform; [
    cargoSetupHook
    rust.cargo
  ]);

  buildInputs = [
    openssl
    sqlite
  ];

  checkInputs = with rustPlatform; [
    cargoCheckHook
  ];

  meta = with lib; {
    description = "Delta Chat Rust Core library";
    homepage = "https://github.com/deltachat/deltachat-core-rust/";
    changelog = "https://github.com/deltachat/deltachat-core-rust/blob/${version}/CHANGELOG.md";
    license = licenses.mpl20;
    platforms = platforms.linux;
    maintainers = with maintainers; [ dotlambda ];
  };
}
