{
  lib,
  stdenv,
  fetchFromGitHub,
  fetchpatch,
  cmake,
}:

stdenv.mkDerivation rec {
  pname = "wla-dx";
  version = "10.6";

  src = fetchFromGitHub {
    owner = "vhelin";
    repo = "wla-dx";
    tag = "v${version}";
    hash = "sha256-t+X1Y1NhAGi4NOPik2fuLZAR3A7NQMAkSgWvqAFaIik=";
  };

  patches = [
    # bymp minimum required cmake
    (fetchpatch {
      url = "https://github.com/vhelin/wla-dx/commit/6fa1f673f010e4fa4571c40929019cd7e67d1bbd.patch?full_index=1";
      hash = "sha256-SBjTzJxJ8XL9h2fMtjYu9RkaH8H/V+pFdiAobL2D98Y=";
    })
  ];

  installPhase = ''
    runHook preInstall

    mkdir -p $out/bin
    install binaries/* $out/bin

    runHook postInstall
  '';

  nativeBuildInputs = [ cmake ];

  meta = {
    homepage = "https://www.villehelin.com/wla.html";
    description = "Yet Another GB-Z80/Z80/6502/65C02/6510/65816/HUC6280/SPC-700 Multi Platform Cross Assembler Package";
    license = lib.licenses.gpl2;
    maintainers = with lib.maintainers; [ matthewbauer ];
    platforms = lib.platforms.all;
  };
}
