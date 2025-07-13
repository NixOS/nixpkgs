{
  lib,
  stdenv,
  fetchurl,
}:

stdenv.mkDerivation rec {
  pname = "tie";
  version = "2.4";

  src = fetchurl {
    url = "https://mirrors.ctan.org/web/tie/${pname}-${version}.tar.gz";
    sha256 = "sha256-AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA=";
  };

  buildPhase = ''
    ${stdenv.cc.targetPrefix}cc -std=c89 tie.c -o tie
  '';

  installPhase = ''
    mkdir -p $out/bin
    cp tie $out/bin
  '';

  meta = with lib; {
    homepage = "https://www.ctan.org/tex-archive/web/tie";
    description = "Allow multiple web change files";
    mainProgram = "tie";
    platforms = platforms.all;
    maintainers = [ ];
    license = licenses.abstyles;
  };
}
