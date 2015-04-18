{stdenv, fetchurl, texinfo, texLive}:
let
  s = # Generated upstream information
  rec {
    baseName="asdf";
    version="3.1.4";
    name="${baseName}-${version}";
    hash="0hyc2g22khcmvxmlcaq0xbxqhq59spgc2nc1s0gz1r9mcgrzm2xw";
    url="http://common-lisp.net/project/asdf/archives/asdf-3.1.4.tar.gz";
    sha256="0hyc2g22khcmvxmlcaq0xbxqhq59spgc2nc1s0gz1r9mcgrzm2xw";
  };
  buildInputs = [
    texinfo texLive
  ];
in
stdenv.mkDerivation {
  inherit (s) name version;
  inherit buildInputs;
  src = fetchurl {
    inherit (s) url sha256;
  };
  sourceRoot=".";
  buildPhase = ''
    make build/asdf.lisp
    make -C doc asdf.info asdf.html
  '';
  installPhase = ''
    mkdir -p "$out"/lib/common-lisp/asdf/
    mkdir -p "$out"/share/doc/asdf/
    cp -r ./* "$out"/lib/common-lisp/asdf/
    cp -r doc/* "$out"/share/doc/asdf/
  '';
  meta = {
    inherit (s) version;
    description = ''Standard software-system definition library for Common Lisp'';
    license = stdenv.lib.licenses.mit ;
    maintainers = [stdenv.lib.maintainers.raskin];
    platforms = stdenv.lib.platforms.linux;
  };
}
