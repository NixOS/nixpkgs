{stdenv, fetchurl, texinfo, texLive}:
let
  s = # Generated upstream information
  rec {
    baseName="asdf";
    version="3.1.2";
    name="${baseName}-${version}";
    hash="0d427908q4hcspmdhc5ps38dbvz113hy6687l9ypmfl79qfb2qki";
    url="http://common-lisp.net/project/asdf/archives/asdf-3.1.2.tar.gz";
    sha256="0d427908q4hcspmdhc5ps38dbvz113hy6687l9ypmfl79qfb2qki";
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
  sourceRoot=".";
  meta = {
    inherit (s) version;
    description = ''Standard software-system definition library for Common Lisp'';
    license = stdenv.lib.licenses.mit ;
    maintainers = [stdenv.lib.maintainers.raskin];
    platforms = stdenv.lib.platforms.linux;
  };
}
