{ stdenv, fetchurl, cpio, rsync, makeWrapper }:

stdenv.mkDerivation rec {
  name = "smlnj-bootstrap-${version}";

  version = "110.80";

  src = fetchurl {
    url = "http://smlnj.cs.uchicago.edu/dist/working/${version}/smlnj-x86-${version}.pkg";
    sha256 = "1709xpgmxa6v73h77y7vn9wf5vlfdk75p61w28nzgfdsdc8f8l65";
  };

  buildInputs = [ cpio rsync makeWrapper ];

  unpackPhase = ''
    /usr/bin/xar -xf $src
    cd smlnj.pkg
  '';

  buildPhase = ''
    cat Payload | gunzip -dc | cpio -i
  '';

  installPhase = ''
    mkdir -p $out/bin
    rsync -av bin/ $out/bin/

    mkdir -p $out/lib
    rsync -av lib/ $out/lib/
  '';

  postInstall = ''
    wrapProgram "$out/bin/sml" --set "SMLNJ_HOME" "$out"
  '';

  meta = {
    description = "Compiler for the Standard ML '97 programming language";
    homepage    = http://www.smlnj.org;
    license     = stdenv.lib.licenses.free;
    platforms   = stdenv.lib.platforms.darwin;
    maintainers = [ stdenv.lib.maintainers.jwiegley ];
  };
}