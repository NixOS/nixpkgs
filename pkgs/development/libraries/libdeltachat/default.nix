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
  version = "1.55.0";

  src = fetchFromGitHub {
    owner = "deltachat";
    repo = "deltachat-core-rust";
    rev = version;
    sha256 = "sha256-D30usAVpyiqXQMrTvmdaGFig7jhyb3rMTBQL/E2UL50=";
  };

  cargoDeps = rustPlatform.fetchCargoTarball {
    inherit src;
    name = "${pname}-${version}";
    sha256 = "1hf7lrqbv0ba9c0kmnjn5x1fispyyjip1gmllq77z6nsjpn0f9w8";
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
