{ lib
, stdenv
, rustPlatform
, pkg-config
, openssl
, fetchFromGitHub
}:
stdenv.mkDerivation rec {
  pname = "libetebase";
  version = "0.5.0";

  src = fetchFromGitHub {
    owner = "etesync";
    repo = "libetebase";
    rev = "v${version}";
    sha256 = "0r6404lgaawwkEsF3HNB+eSJ+nkEeUHUiIKUNxFDAGc=";
  };

  cargoDeps = rustPlatform.fetchCargoTarball {
    inherit src;
    name = "${pname}-${version}";
    sha256 = "0w04n78b9vjsd1vaz1yrqwr3s7a38qag09qsqc71rvbsar2rmzwz";
  };

  nativeBuildInputs = [
    pkg-config
  ] ++ (with rustPlatform; [
    cargoSetupHook
    rust.cargo
  ]);

  buildInputs = [
    openssl
  ];

  checkInputs = with rustPlatform; [
    cargoCheckHook
  ];

  installFlags = [ "PREFIX=$out" ];

  postInstall = ''
    # For references in evolution-etesync
    mkdir -p $out/include
    ln -s $out/include/etebase/etebase.h $out/include/etebase.h
    ln -s $out/lib/libetebase.so $out/lib/libetebase.so.0
  '';

  meta = with lib; {
    description = "A C library for Etebase";
    homepage = "https://github.com/etesync/libetebase/";
    license = licenses.bsd3;
    maintainers = with maintainers; [ pacman99 ];
  };
}
