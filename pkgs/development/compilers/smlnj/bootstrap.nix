# This derivation should be redundant, now that regular smlnj works on Darwin,
# and is preserved only for pre-existing direct usage. New use cases should
# just use the regular smlnj derivation.

{
  lib,
  stdenv,
  fetchurl,
  cpio,
  rsync,
  xar,
  makeWrapper,
}:

stdenv.mkDerivation rec {
  pname = "smlnj-bootstrap";

  version = "110.91";

  src = fetchurl {
    url = "https://smlnj.cs.uchicago.edu/dist/working/${version}/smlnj-x86-${version}.pkg";
    sha256 = "sha256-AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA=";
  };

  nativeBuildInputs = [ makeWrapper ];
  buildInputs = [
    cpio
    rsync
  ];

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
    homepage = "http://www.smlnj.org";
    license = lib.licenses.free;
    platforms = lib.platforms.darwin;
    maintainers = [ lib.maintainers.jwiegley ];
    mainProgram = "sml";
  };
}
