{ lib
, stdenvNoCC
, fetchFromGitHub
, fetchurl
, clickgen
, unzip
}:

stdenvNoCC.mkDerivation rec {
  pname = "bibata-extra-cursors";
  version = "1.0.1";

  src = fetchFromGitHub {
    owner = "ful1e5";
    repo = "Bibata_Extra_Cursor";
    rev = "v${version}";
    sha256 = "0wndl4c547k99y0gq922hn7z1mwdgxvvyjfm6757g6shfbcmkz7m";
  };

  bitmaps = fetchurl {
    url = "https://github.com/ful1e5/Bibata_Extra_Cursor/releases/download/v${version}/bitmaps.zip";
    sha256 = "0vf14ln53wigaq3dkqdk5avarqplsq751nlv72da04ms6gqjfhdl";
  };

  nativeBuildInputs = [ unzip ];

  buildInputs = [ clickgen ];

  buildPhase = ''
    mkdir bitmaps
    unzip $bitmaps -d bitmaps
    rm -rf themes
    cd builder && make build_unix
  '';

  installPhase = ''
    install -dm 0755 $out/share/icons
    cd ../
    cp -rf themes/* $out/share/icons/
  '';

  postPatch = ''
    substituteInPlace "builder/Makefile" \
      --replace "/bin/bash" "bash"
  '';

  meta = with lib; {
    description = "Material Based Cursor Theme";
    homepage = "https://github.com/ful1e5/Bibata_Extra_Cursor";
    license = licenses.gpl3;
    platforms = platforms.linux;
    maintainers = with maintainers; [ dtzWill AdsonCicilioti ];
  };
}
