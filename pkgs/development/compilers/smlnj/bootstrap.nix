{ stdenv, fetchurl, cpio, rsync, xar, makeWrapper }:

stdenv.mkDerivation rec {
  pname = "smlnj-bootstrap";

  version = "110.91";

  src = fetchurl {
    url = "http://smlnj.cs.uchicago.edu/dist/working/${version}/smlnj-x86-${version}.pkg";
    sha256 = "12jn50h5jz0ac1vzld2mb94p1dyc8h0mk0hip2wj5xqk1dbzwxl4";
  };

  buildInputs = [ cpio rsync makeWrapper ];

  unpackPhase = ''
    ${xar}/bin/xar -xf $src
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
    homepage    = "http://www.smlnj.org";
    license     = stdenv.lib.licenses.free;
    platforms   = stdenv.lib.platforms.darwin;
    maintainers = [ stdenv.lib.maintainers.jwiegley ];
  };
}
