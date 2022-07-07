{lib, stdenv, fetchFromGitHub, bison, flex, pkg-config, libpng}:

stdenv.mkDerivation rec {
  pname = "rgbds";
  version = "0.5.2";
  src = fetchFromGitHub {
    owner = "gbdev";
    repo = "rgbds";
    rev = "v${version}";
    sha256 = "sha256-/GjxdB3Nt+XuKKQWjU12mS91U4FFoeP+9t0L+HsB/o8=";
  };
  nativeBuildInputs = [ bison flex pkg-config ];
  buildInputs = [ libpng ];
  NIX_CFLAGS_COMPILE = lib.optional stdenv.isDarwin "-fno-lto";
  installFlags = [ "PREFIX=${placeholder "out"}" ];

  meta = with lib; {
    homepage = "https://rgbds.gbdev.io/";
    description = "A free assembler/linker package for the Game Boy and Game Boy Color";
    license = licenses.mit;
    longDescription =
      ''RGBDS (Rednex Game Boy Development System) is a free assembler/linker package for the Game Boy and Game Boy Color. It consists of:

          - rgbasm (assembler)
          - rgblink (linker)
          - rgbfix (checksum/header fixer)
          - rgbgfx (PNG‐to‐Game Boy graphics converter)

        This is a fork of the original RGBDS which aims to make the programs more like other UNIX tools.
      '';
    maintainers = with maintainers; [ matthewbauer NieDzejkob ];
    platforms = platforms.all;
  };
}
