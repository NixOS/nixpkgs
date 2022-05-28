{ lib, stdenv, fetchurl, Libsystem, installShellFiles, coreutils }:
let
  version = "110.99.2";
  baseurl = "http://smlnj.cs.uchicago.edu/dist/working/${version}";

  arch = if stdenv.is64bit
    then "64"
    else "32";

  boot32 = { url = "${baseurl}/boot.x86-unix.tgz";
             sha256 = "sha256-mK1NlYrT+Kiy9Qk9K4cgL/8HzuGXtgJC8GwfNF7A7YQ="; };
  boot64 = { url = "${baseurl}/boot.amd64-unix.tgz";
             sha256 = "sha256-zkmZhaiHA7ubn6eZVoyU6QWl0vwXVLqIEh6M2zX6ajE="; };

  bootBinary = if stdenv.is64bit
               then boot64
               else boot32;

  sources = map fetchurl [
    bootBinary
    { url = "${baseurl}/config.tgz";              sha256 = "sha256-T9uyr2JmM3FayJqsvf8xGJcyVOteQ7UOQHsa07IDBus="; }
    { url = "${baseurl}/cm.tgz";                  sha256 = "sha256-TEJsTJNchzB0anKmKjfSC0ekj5Ym2kzEgtv7nWby/iA="; }
    { url = "${baseurl}/compiler.tgz";            sha256 = "sha256-1uJtqGqFQxPjSyRTyObpE7Tq/se4qxLye7gBtWLNO5E="; }
    { url = "${baseurl}/runtime.tgz";             sha256 = "sha256-g3mRgv34GGqkX3exV6rGZvr9Tlbhj5u6DimPKDI+eDA="; }
    { url = "${baseurl}/system.tgz";              sha256 = "sha256-6gMLRg6VqKUDsaR3FRVKlGd6u/adypv0Ri7FnyC21Ck="; }
    { url = "${baseurl}/MLRISC.tgz";              sha256 = "sha256-5FyNyObdaIry5Evz6EBHzLj+EM5wYeiRToBbfPJRb84="; }
    { url = "${baseurl}/smlnj-lib.tgz";           sha256 = "sha256-AdDGDRTWfYfulycjUvB7Nx7EGdl8Lug29WMCVOzD25E="; }
    { url = "${baseurl}/old-basis.tgz";           sha256 = "sha256-wbrQ3JKkuTNq5wdUkOgbpA+2y1JZ2b5l5zM03zVQR4Y="; }
    { url = "${baseurl}/ckit.tgz";                sha256 = "sha256-OFpk1aFs3Wzm5tg369w2auqPEBoQQ1k+m99k6MSSbrk="; }
    { url = "${baseurl}/nlffi.tgz";               sha256 = "sha256-sj5WtaFg3vkvaer2PcCeoujIb2lrBkTCga6XJPo5v1w="; }
    { url = "${baseurl}/cml.tgz";                 sha256 = "sha256-lvG2ox8g1XtYyisDqXGChIA8aw52Pk0nh90qXpWCrI8="; }
    { url = "${baseurl}/eXene.tgz";               sha256 = "sha256-iyf6c5PjadgrWKmgXwsYOPxz6/JJVZSgKEkFBSi2mlw="; }
    { url = "${baseurl}/ml-lpt.tgz";              sha256 = "sha256-b+Hifbe3l2NVANF26lckURX5I0IbG6//bVeV9OjbAFQ="; }
    { url = "${baseurl}/ml-lex.tgz";              sha256 = "sha256-TAoaVCSGsOSBnBFXMWkzDyTHTt2btBOdLTA4Jjkusd4="; }
    { url = "${baseurl}/ml-yacc.tgz";             sha256 = "sha256-d4QOGRQglLKTcWljdaQ5As6OBq8iJ30Lmigjm0MViv4="; }
    { url = "${baseurl}/ml-burg.tgz";             sha256 = "sha256-/Xwa2SDkMmVhGrFlztrM21Ae5pN/engT6OMIpZVWmJE="; }
    { url = "${baseurl}/pgraph.tgz";              sha256 = "sha256-aZZF4Eqo9CIiubH4TiELqwu228OR1GL7nYUp2oPZbqA="; }
    { url = "${baseurl}/trace-debug-profile.tgz"; sha256 = "sha256-KKiI5vi7aCpNbhIgGLAq5N8c+uvonFO/vHWQPAMqHMw="; }
    { url = "${baseurl}/heap2asm.tgz";            sha256 = "sha256-NtUAETwkNvjR6IgQqBP/P48ah8bOVB4AAbA/y5QgOl0="; }
    { url = "${baseurl}/smlnj-c.tgz";             sha256 = "sha256-tdscblcHK8wqm29V8r5M7CP8MQIzhBuAlGL68qANixQ="; }
    { url = "${baseurl}/doc.tgz";                 sha256 = "sha256-EmF3uKoBnyCF19dbuQmljhoLgIwoBnZ++9wc2Xr+ZWg="; }
    { url = "${baseurl}/asdl.tgz";                sha256 = "sha256-FayP8n3qmjP/tFLWBo2ib0RTjaqdupfM0m3WW1wTTVU="; }
  ];
in stdenv.mkDerivation {
  pname = "smlnj";
  inherit version;

  inherit sources;

  patchPhase = ''
    substituteInPlace base/runtime/config/gen-posix-names.sh \
      --replace "PATH=/bin:/usr/bin" ""
    echo SRCARCHIVEURL="file:/$TMP" > config/srcarchiveurl
  '' + lib.optionalString stdenv.isDarwin ''
    # Locate standard headers like <unistd.h>
    sed -i 's|XCODE_SDK_PATH=.*|XCODE_SDK_PATH=${Libsystem}|; s|XCODE_DEV_PATH=.*|XCODE_DEV_PATH=${Libsystem}|; s|INCLFILE=.*|INCLFILE=${Libsystem}/include/unistd.h|' base/runtime/config/gen-posix-names.sh
  '';

  nativeBuildInputs = [ installShellFiles ]
    ++ lib.optionals stdenv.isLinux [ coreutils ];

  unpackPhase = ''
    for s in $sources; do
      b=$(basename $s)
      cp $s ''${b#*-}
    done
    unpackFile config.tgz
    unpackFile doc.tgz
    mkdir base
    ./config/unpack $TMP runtime
  '';

  buildPhase = ''
    ./config/install.sh -default ${arch}
  '';

  installPhase = ''
    mkdir -pv $out
    cp -rv bin lib $out
    installManPage doc/man/man*/*

    cd $out/bin
    for i in *; do
      sed -i "2iSMLNJ_HOME=$out/" $i
    done
  '';

  meta = with lib; {
    description = "Standard ML of New Jersey, a compiler";
    homepage    = "https://smlnj.org/";
    changelog   = "https://smlnj.org/dist/working/${version}/HISTORY.html";
    license     = licenses.bsd3;
    platforms   = [ "x86_64-linux" "i686-linux" "x86_64-darwin" ];
    maintainers = with maintainers; [ thoughtpolice marsam ];
    mainProgram = "sml";
  };
}
