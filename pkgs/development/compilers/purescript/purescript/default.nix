{
  stdenv,
  pkgs,
  fetchurl,
  zlib,
  gmp,
  lib,
}:

# from justinwoo/easy-purescript-nix
# https://github.com/justinwoo/easy-purescript-nix/blob/d383972c82620a712ead4033db14110497bc2c9c/purs.nix

stdenv.mkDerivation rec {
  pname = "purescript";
  version = "0.15.16";

  # These hashes can be updated automatically by running the ./update.sh script.
  src =
    let
      url = "https://github.com/${pname}/${pname}/releases/download/v${version}/";
      sources = {
        "x86_64-linux" = fetchurl {
          url = url + "linux64.tar.gz";
          sha256 = "08lfyddh914z7v2ph6im88g9hjvs6z60ldfmiyg5252fibxrxnj4";
        };
        "aarch64-linux" = fetchurl {
          url = url + "linux-arm64.tar.gz";
          sha256 = "1wr7m59v7nakyzgnq2rbm4a8x0dm8arlx0lhi9hwkn70qv2m7ldq";
        };
        "x86_64-darwin" = fetchurl {
          url = url + "macos.tar.gz";
          sha256 = "1djq37w7vhfmvk61cx8rmlckzkh90aywc2v60rqiq938ljvzsnwz";
        };
        "aarch64-darwin" = fetchurl {
          url = url + "macos-arm64.tar.gz";
          sha256 = "1i7w6a9j1k3v1c20g9jxd2v2jr7nsx54lp02zdhc5vr6w89mmwb3";
        };
      };
    in
    sources.${stdenv.hostPlatform.system}
      or (throw "Unsupported system: ${stdenv.hostPlatform.system}");

  buildInputs = [
    zlib
    gmp
  ];
  libPath = lib.makeLibraryPath buildInputs;
  dontStrip = true;

  installPhase = ''
    mkdir -p $out/bin
    PURS="$out/bin/purs"

    install -D -m555 -T purs $PURS
  ''
  + lib.optionalString (stdenv.buildPlatform.canExecute stdenv.hostPlatform) ''
    mkdir -p $out/share/bash-completion/completions
    $PURS --bash-completion-script $PURS > $out/share/bash-completion/completions/purs-completion.bash
  '';

  passthru = {
    updateScript = ./update.sh;
    tests = {
      minimal-module = pkgs.callPackage ./test-minimal-module { };
    };
  };

  meta = {
    description = "Strongly-typed functional programming language that compiles to JavaScript";
    homepage = "https://www.purescript.org/";
    license = lib.licenses.bsd3;
    sourceProvenance = with lib.sourceTypes; [ binaryNativeCode ];
    maintainers = with lib.maintainers; [
      justinwoo
      mbbx6spp
      cdepillabout
    ];
    platforms = [
      "x86_64-linux"
      "aarch64-linux"
      "x86_64-darwin"
      "aarch64-darwin"
    ];
    mainProgram = "purs";
    changelog = "https://github.com/purescript/purescript/releases/tag/v${version}";
  };
}
