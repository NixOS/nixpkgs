{stdenv, fetchurl, texinfo, texLive, perl}:
let
  s = # Generated upstream information
  rec {
    baseName="asdf";
    version="3.2.0";
    name="${baseName}-${version}";
    hash="0ns4hh5f0anfgvy4q68wsylgwfin82kb1k2p53h29cf8jiil0p9a";
    url="http://common-lisp.net/project/asdf/archives/asdf-3.2.0.tar.gz";
    sha256="0ns4hh5f0anfgvy4q68wsylgwfin82kb1k2p53h29cf8jiil0p9a";
  };
  buildInputs = [
    texinfo texLive perl
  ];
in
stdenv.mkDerivation {
  inherit (s) name version;
  inherit buildInputs;
  src = fetchurl {
    inherit (s) url sha256;
  };

  buildPhase = ''
    make build/asdf.lisp
    make -C doc asdf.info asdf.html
  '';
  installPhase = ''
    mkdir -p "$out"/lib/common-lisp/asdf/
    mkdir -p "$out"/share/doc/asdf/
    cp -r ./* "$out"/lib/common-lisp/asdf/
    cp -r doc/* "$out"/share/doc/asdf/
    ln -s  "$out"/lib/common-lisp/{asdf/uiop,uiop}
  '';
  meta = {
    inherit (s) version;
    description = ''Standard software-system definition library for Common Lisp'';
    license = stdenv.lib.licenses.mit ;
    maintainers = [stdenv.lib.maintainers.raskin];
    platforms = stdenv.lib.platforms.linux;
  };
}
