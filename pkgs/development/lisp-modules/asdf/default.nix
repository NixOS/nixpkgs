{stdenv, fetchurl, texinfo, texLive}:
let
  s = # Generated upstream information
  rec {
    baseName="asdf";
    version="3.1.3";
    name="${baseName}-${version}";
    hash="11jgbl2ys98i7lir0z76g0msm89zmz1b91gwkdz0gnxr6gavj6cn";
    url="http://common-lisp.net/project/asdf/archives/asdf-3.1.3.tar.gz";
    sha256="11jgbl2ys98i7lir0z76g0msm89zmz1b91gwkdz0gnxr6gavj6cn";
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
