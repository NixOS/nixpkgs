{lib, stdenv, fetchFromGitHub, bison, flex, pkg-config, libpng}:

stdenv.mkDerivation rec {
  pname = "rgbds";
  version = "0.5.1";
  src = fetchFromGitHub {
    owner = "gbdev";
    repo = "rgbds";
    rev = "v${version}";
    sha256 = "11b1hg2m2f60q5622rb0nxhrzzylsxjx0c8inbxifi6lvmj9ak4x";
  };
  nativeBuildInputs = [ bison flex pkg-config libpng ];
  installFlags = [ "PREFIX=\${out}" ];

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
