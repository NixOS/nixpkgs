{ stdenv, pkgs, fetchurl, zlib, gmp, ncurses5, lib }:

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
  pname = "purescript";
  version = "0.14.2";

  src =
    if stdenv.isDarwin
    then
    fetchurl {
      url = "https://github.com/${pname}/${pname}/releases/download/v${version}/macos.tar.gz";
      sha256 = "1ga2hn9br71dyzn3p9jvjiksvnq21p6i5hp1z1j5fpz9la28nqzf";
    }
    else
    fetchurl {
      url = "https://github.com/${pname}/${pname}/releases/download/v${version}/linux64.tar.gz";
      sha256 = "1kv7dm1nw85lw3brrclkj7xc9p021jx3n8wgp2fg3572s86ypskw";
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

    mkdir -p $out/share/bash-completion/completions
    $PURS --bash-completion-script $PURS > $out/share/bash-completion/completions/purs-completion.bash
  '';

  passthru.tests = {
    minimal-module = pkgs.callPackage ./test-minimal-module {};
  };

  meta = with lib; {
    description = "A strongly-typed functional programming language that compiles to JavaScript";
    homepage = "https://www.purescript.org/";
    license = licenses.bsd3;
    maintainers = with maintainers; [ justinwoo mbbx6spp cdepillabout ];
    platforms = [ "x86_64-linux" "x86_64-darwin" ];
    mainProgram = "purs";
    changelog = "https://github.com/purescript/purescript/releases/tag/v${version}";
  };
}
