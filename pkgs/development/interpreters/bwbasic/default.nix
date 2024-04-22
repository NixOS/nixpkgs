{ lib, stdenv, dos2unix, fetchurl, unzip }:

stdenv.mkDerivation rec {
  pname = "bwbasic";
  version = "3.20";

  src = fetchurl {
    url = "mirror://sourceforge/project/bwbasic/bwbasic/version%203.20/bwbasic-3.20.zip";
    sha256 = "1w9r4cl7z1lh52c1jpjragbspi1qn0zb7jhcsldav4gdnzxfw67f";
  };

  nativeBuildInputs = [ dos2unix unzip ];

  unpackPhase = ''
    unzip $src
  '';

  postPatch = ''
    dos2unix configure
    patchShebangs configure
    chmod +x configure
  '';

  hardeningDisable = [ "format" ];

  preInstall = ''
    mkdir -p $out/bin
  '';

  meta = with lib; {
    description = "Bywater BASIC Interpreter";
    mainProgram = "bwbasic";
    license = licenses.gpl2Only;
    maintainers = with maintainers; [ irenes ];
    platforms = platforms.all;
    homepage = "https://sourceforge.net/projects/bwbasic/";
  };
}
