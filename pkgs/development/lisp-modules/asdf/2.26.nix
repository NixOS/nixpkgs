{stdenv, fetchurl, texinfo, texLive, perl}:
let
  s = # Generated upstream information
  rec {
    baseName="asdf";
    version="2.26";
    name="${baseName}-${version}";
    url="http://common-lisp.net/project/asdf/archives/asdf-${version}.tar.gz";
    sha256="1qzp444rgnqf1cz9v48nh0yvz7wjq9fjdpimifsfcjswaqi2xrdn";
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
    make asdf.lisp
    mkdir build
    ln -s ../asdf.lisp build
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
