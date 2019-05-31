{ stdenv, fetchurl, zlib, gmp, ncurses5, lib }:

# from justinwoo/easy-purescript-nix
# https://github.com/justinwoo/easy-purescript-nix/blob/d383972c82620a712ead4033db14110497bc2c9c/purs.nix

let
  dynamic-linker = stdenv.cc.bintools.dynamicLinker;

  patchelf = libPath :
    if stdenv.isDarwin
      then ""
      else
        ''
          chmod u+w $PURS
          patchelf --interpreter ${dynamic-linker} --set-rpath ${libPath} $PURS
          chmod u-w $PURS
        '';

  revisions = builtins.fromJSON (builtins.readFile ./revision.json);
in stdenv.mkDerivation rec {
  pname = "purescript";

  version = revisions.version;

  src = if stdenv.isDarwin
    then fetchurl { inherit (revisions.mac) url sha256; }
    else fetchurl { inherit (revisions.linux) url sha256; };

  buildInputs = [ zlib
                  gmp
                  ncurses5 ];
  libPath = lib.makeLibraryPath buildInputs;
  dontStrip = true;

  installPhase = ''
    mkdir -p $out/bin
    PURS="$out/bin/purs"

    install -D -m555 -T purs $PURS
    ${patchelf libPath}

    mkdir -p $out/etc/bash_completion.d/
    $PURS --bash-completion-script $PURS > $out/etc/bash_completion.d/purs-completion.bash
  '';
  meta = with stdenv.lib; {
    description = "A strongly-typed functional programming language that compiles to JavaScript";
    homepage = http://www.purescript.org/;
    license = licenses.bsd3;
    maintainers = [ maintainers.justinwoo ];
    platforms = [ "x86_64-linux" "x86_64-darwin" ];
  };
}
