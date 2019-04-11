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

in stdenv.mkDerivation rec {
  name = "purs-simple";
  version = "v0.12.4";

  src =
    if stdenv.isDarwin
    then
    fetchurl {
      url = "https://github.com/purescript/purescript/releases/download/v0.12.4/macos.tar.gz";
      sha256 = "046b18plakwvqr77x1hybhfiyzrhnnq0q5ixcmypri1mkkdsmczx";
    }
    else
    fetchurl {
      url = "https://github.com/purescript/purescript/releases/download/v0.12.4/linux64.tar.gz";
      sha256 = "18yny533sjfgacxqx1ki306nhznj4q6nv52c83l82gqj8amyj7k0";
    };


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
