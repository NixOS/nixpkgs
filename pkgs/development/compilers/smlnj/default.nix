{ lib, stdenv, fetchurl, Libsystem }:
let
  version = "110.99.5";
  baseurl = "http://smlnj.cs.uchicago.edu/dist/working/${version}";

  arch = if stdenv.is64bit
    then "64"
    else "32";

  boot32 = { url = "${baseurl}/boot.x86-unix.tgz";
             hash = "sha256-9yU9gBTN/z1kEcv1y8OPq+4Y0pFLzUNB8pTmf3K4M2U="; };
  boot64 = { url = "${baseurl}/boot.amd64-unix.tgz";
             hash = "sha256-pfGpnx4qzcGLkdHEXj108DSaGajXgZWT/Ms99+rrYbs="; };

  bootBinary = if stdenv.is64bit
               then boot64
               else boot32;

  sources = map fetchurl [
    bootBinary
    { url = "${baseurl}/config.tgz";              hash = "sha256-8yuVv1L1t1Ep4kIuVv0+2xI2YX12A9DHZsPIBDjN0V0="; }
    { url = "${baseurl}/cm.tgz";                  hash = "sha256-bRrH3yjJnypTGhg0VL+25G2G+/3Ze63ggHDgAByhTrI="; }
    { url = "${baseurl}/compiler.tgz";            hash = "sha256-l7WeUhOexpjkkQjhJ0nHdAVetuKKt8CFE859NXqONh0="; }
    { url = "${baseurl}/runtime.tgz";             hash = "sha256-cSV8Uv3EHU96/KsF//RJYPXJizAO7VmKnIlvDkWCbTA="; }
    { url = "${baseurl}/system.tgz";              hash = "sha256-vB24eqXTmtzjElLzeKwS4bhGg2lpW+Ef3lewx5W6vMM="; }
    { url = "${baseurl}/MLRISC.tgz";              hash = "sha256-ZjzbbWrvfw1f+0vfhoCcFHiIRoz6F/QbuhfTJEkzGgY="; }
    { url = "${baseurl}/smlnj-lib.tgz";           hash = "sha256-B7B+gSgh/tb5ZeQoJuonDgS4RSUc5TYs/3yJ5jsCgo0="; }
    { url = "${baseurl}/old-basis.tgz";           hash = "sha256-584UQ4PsqO12KrR4t27gRXk0YyExu2ksAGq4jIGXhpE="; }
    { url = "${baseurl}/ckit.tgz";                hash = "sha256-TbeODlBfhRlTTntrF3lIoIH7m3sjkgoh29XSv6UUYaw="; }
    { url = "${baseurl}/nlffi.tgz";               hash = "sha256-frIqBvzMBdrCfURGRX3Pln8bpBLa/ZQPc6n9wRAExUs="; }
    { url = "${baseurl}/cml.tgz";                 hash = "sha256-9yU9gBTN/z1kEcv1y8OPq+4Y0pFLzUNB8pTmf3K4M2U="; }
    { url = "${baseurl}/eXene.tgz";               hash = "sha256-hdoI/6M6FZcIsd5eJf1DDhiTWV3TuPFfA5dR9iU43lU="; }
    { url = "${baseurl}/ml-lpt.tgz";              hash = "sha256-9U8GoL1n2NzyKh0tiRqWaKLa4RS4h1q9oGGhgaINZ7E="; }
    { url = "${baseurl}/ml-lex.tgz";              hash = "sha256-NnpcyyyV+eC3Ebw77r1mJEiLbG8nZl4jaV7fP1QJGZo="; }
    { url = "${baseurl}/ml-yacc.tgz";             hash = "sha256-gjVBk8grQLj0+uC2+zTo/X5TrcaCb0xkbRry9IsT56Q="; }
    { url = "${baseurl}/ml-burg.tgz";             hash = "sha256-XGC60kS/w5nxJe0IHWxHz/xwgsmKoukTl4pjdFjIzw0="; }
    { url = "${baseurl}/pgraph.tgz";              hash = "sha256-VSQ0nPFlbuepbVRZCmYa5wOvQUbP0MXRra0V8lrvIKw="; }
    { url = "${baseurl}/trace-debug-profile.tgz"; hash = "sha256-1lW/zJiiZFOYjFNOQJIzMP4Ms7M0QdYIHHAoDiKN6Kc="; }
    { url = "${baseurl}/heap2asm.tgz";            hash = "sha256-71eHCwSaVoYWnItIkXl7EuB9ZLk9WpEvdIbmRW+o4a0="; }
    { url = "${baseurl}/smlnj-c.tgz";             hash = "sha256-anKS6PqxElOz6MYB7dyd/dqJaah7CyIm8FjGu3/C4h8="; }
    { url = "${baseurl}/doc.tgz";                 hash = "sha256-Yy0dGhT997szNFbTX7aYuDI/dUxDmH1Z035iIUIeDxY="; }
    { url = "${baseurl}/asdl.tgz";                hash = "sha256-hJa1Rk/GHkCwV2zycTYZJC8Kh24tghrTvsCbAcWrNz8="; }
  ];
in stdenv.mkDerivation {
  pname = "smlnj";
  inherit version;

  inherit sources;

  patchPhase = ''
    sed -i '/^PATH=/d' config/_arch-n-opsys base/runtime/config/gen-posix-names.sh
    echo SRCARCHIVEURL="file:/$TMP" > config/srcarchiveurl
  '' + lib.optionalString stdenv.isDarwin ''
    # Locate standard headers like <unistd.h>
    substituteInPlace base/runtime/config/gen-posix-names.sh \
      --replace "\$SDK_PATH/usr" "${Libsystem}"
  '';

  unpackPhase = ''
    for s in $sources; do
      b=$(basename $s)
      cp $s ''${b#*-}
    done
    unpackFile config.tgz
    mkdir base
    ./config/unpack $TMP runtime
  '';

  buildPhase = ''
    ./config/install.sh -default ${arch}
  '';

  installPhase = ''
    mkdir -pv $out
    cp -rv bin lib $out

    cd $out/bin
    for i in *; do
      sed -i "2iSMLNJ_HOME=$out/" $i
    done
  '';

  meta = with lib; {
    description = "Standard ML of New Jersey, a compiler";
    homepage    = "http://smlnj.org";
    license     = licenses.bsd3;
    platforms   = [ "x86_64-linux" "i686-linux" "x86_64-darwin" ];
    maintainers = with maintainers; [ thoughtpolice ];
    mainProgram = "sml";
    # never built on x86_64-darwin since first introduction in nixpkgs
    broken = stdenv.isDarwin && stdenv.isx86_64;
  };
}
