{stdenv, fetchurl, texinfo, texLive, perl}:
let
  s = # Generated upstream information
  rec {
    baseName="asdf";
    version="3.1.7";
    name="${baseName}-${version}";
    url="http://common-lisp.net/project/asdf/archives/asdf-${version}.tar.gz";
    sha256="1g8wp3vi7gwrs22gnjy9lvrxqag3m8apxnryfs8n5bv6rln8bzzq";
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
