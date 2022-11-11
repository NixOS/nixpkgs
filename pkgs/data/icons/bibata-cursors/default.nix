{ lib
, stdenvNoCC
, fetchFromGitHub
, fetchurl
, clickgen
, unzip
}:

stdenvNoCC.mkDerivation rec {
  pname = "bibata-cursors";
  version = "1.1.2";

  src = fetchFromGitHub {
    owner = "ful1e5";
    repo = "Bibata_Cursor";
    rev = "v${version}";
    sha256 = "1q2wdbrmdnr9mwiilm5cc9im3zwbl7yaj1zpy5wwn44ypq3hcngy";
  };

  bitmaps = fetchurl {
    url = "https://github.com/ful1e5/Bibata_Cursor/releases/download/v${version}/bitmaps.zip";
    sha256 = "1pcn6par0f0syyhzpzmqr3c6b9ri4lprkdd2ncwzdas01p2d9v1i";
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
    homepage = "https://github.com/ful1e5/Bibata_Cursor";
    license = licenses.gpl3;
    platforms = platforms.linux;
    maintainers = with maintainers; [ rawkode AdsonCicilioti ];
  };
}
