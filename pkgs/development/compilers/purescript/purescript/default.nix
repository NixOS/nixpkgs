{ stdenv, pkgs, fetchurl, zlib, gmp, lib }:

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
  version = "0.15.9";

  # These hashes can be updated automatically by running the ./update.sh script.
  src =
    if stdenv.isDarwin
    then
      (if stdenv.isAarch64
      then
      fetchurl {
        url = "https://github.com/${pname}/${pname}/releases/download/v${version}/macos-arm64.tar.gz";
        sha256 = "16ci26pgrw0zmnyn1zj129y9624cqwzrhqglc8mgfg4k7rxvqy2a";
      }
      else
      fetchurl {
        url = "https://123.github.com/${pname}/${pname}/releases/download/v${version}/macos.tar.gz";
        sha256 = "1xxg79rlf7li9f73wdbwif1dyy4hnzpypy6wx4zbnvap53habq9f";
      })
    else
    fetchurl {
      url = "https://github.com/${pname}/${pname}/releases/download/v${version}/linux64.tar.gz";
      sha256 = "0rabinklsd8bs16f03zv7ij6d1lv4w2xwvzzgkwc862gpqvz9jq3";
    };


  buildInputs = [ zlib gmp ];
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

  passthru = {
    updateScript = ./update.sh;
    tests = {
      minimal-module = pkgs.callPackage ./test-minimal-module {};
    };
  };

  meta = with lib; {
    description = "A strongly-typed functional programming language that compiles to JavaScript";
    homepage = "https://www.purescript.org/";
    license = licenses.bsd3;
    sourceProvenance = with lib.sourceTypes; [ binaryNativeCode ];
    maintainers = with maintainers; [ justinwoo mbbx6spp cdepillabout ];
    platforms = [ "x86_64-linux" "x86_64-darwin" "aarch64-darwin" ];
    mainProgram = "purs";
    changelog = "https://github.com/purescript/purescript/releases/tag/v${version}";
  };
}
