{
  lib,
  stdenv,
  fetchurl,
  Libsystem,
}:
let
  version = "110.99.6.1";
  baseurl = "http://smlnj.cs.uchicago.edu/dist/working/${version}";

  arch = if stdenv.hostPlatform.is64bit then "64" else "32";

  boot32 = {
    url = "${baseurl}/boot.x86-unix.tgz";
    hash = "sha256-2yBY0wGZ8B1jYC5os9SfH6eKJoWlQ4rAclBC3Pnacoc=";
  };
  boot64 = {
    url = "${baseurl}/boot.amd64-unix.tgz";
    hash = "sha256-kUabK03MdSYVRWhWKl3kS32SExUYpM3MtLU0mCxhiaQ=";
  };

  bootBinary = if stdenv.hostPlatform.is64bit then boot64 else boot32;

  sources = map fetchurl [
    bootBinary
    {
      url = "${baseurl}/config.tgz";
      hash = "sha256-9BJPpa/xouqi3j39WsfzlRys4z1yxTdbYttHF5VwCVw=";
    }
    {
      url = "${baseurl}/cm.tgz";
      hash = "sha256-A3crC5EWX4kEB6olwdaObglQgkBBNqcBSCi/pQR5Wdw=";
    }
    {
      url = "${baseurl}/compiler.tgz";
      hash = "sha256-cTgkc5opaEXskdzt5yYsdjyF5m9846t2SyEiwY6W3HU=";
    }
    {
      url = "${baseurl}/runtime.tgz";
      hash = "sha256-JiNzfuZnp1eWQPNZBb9SPmQXtwgknpoGl+38iqUU3W4=";
    }
    {
      url = "${baseurl}/system.tgz";
      hash = "sha256-HUn8YCxlLe6+e5H9oMJjIoG23GBF3thMlHEkSGLZTus=";
    }
    {
      url = "${baseurl}/MLRISC.tgz";
      hash = "sha256-MPNpYhrbsIbVEOzJ7GIEQCm/7F/Jnxj0UXS7FeTp+7o=";
    }
    {
      url = "${baseurl}/smlnj-lib.tgz";
      hash = "sha256-1tp5waPl7MCWS4kIUFm/woQeeRfCjkpgSxHpGb+ymTM=";
    }
    {
      url = "${baseurl}/old-basis.tgz";
      hash = "sha256-I6DJRfIx+09ynFKXZ63dDWRpv0pEljWciAarK/EhQ/s=";
    }
    {
      url = "${baseurl}/ckit.tgz";
      hash = "sha256-vi6dSZISL+KWkpp/jxLPCNBno+qTYThvbExZ5R5L7Wc=";
    }
    {
      url = "${baseurl}/nlffi.tgz";
      hash = "sha256-WfYmX7dhrBqtE4juDVNyjuFtsJ1H+B7rJY2BXJYtKNM=";
    }
    {
      url = "${baseurl}/cml.tgz";
      hash = "sha256-5rZzp5IUj/xZX0fyeoNMohyTz1ifdY6Anu/Hg0spDQw=";
    }
    {
      url = "${baseurl}/eXene.tgz";
      hash = "sha256-c5QnjAQTtlBgYE6DGFMNDbu9ILSEVZgzs/u0bIowfHc=";
    }
    {
      url = "${baseurl}/ml-lpt.tgz";
      hash = "sha256-aRYFTEEl4td7LQ0LhsXGLtJ/ptwCDV1m9GeDtM7+vlo=";
    }
    {
      url = "${baseurl}/ml-lex.tgz";
      hash = "sha256-ZwO3xQUDaD2f7Tsro6kkahT7vSN1JvQbLkwY/m7xSIs=";
    }
    {
      url = "${baseurl}/ml-yacc.tgz";
      hash = "sha256-DBR4xmKiSA5on7+YDz7Zr8qBA6aD1fS64+g69ukSprc=";
    }
    {
      url = "${baseurl}/ml-burg.tgz";
      hash = "sha256-4ruWhGjxny97eUD9Gk4FakqEZzNHwJp7uSa97ET20p0=";
    }
    {
      url = "${baseurl}/pgraph.tgz";
      hash = "sha256-kDyaAMB6Pt3CdAna+V8aLfTx8Tj6a5vPfuSxtpga08w=";
    }
    {
      url = "${baseurl}/trace-debug-profile.tgz";
      hash = "sha256-AD9KWsskRkjTFYiRCIm0qj02sIBHG6HtBM5wKMBqeXY=";
    }
    {
      url = "${baseurl}/heap2asm.tgz";
      hash = "sha256-OHNPMErNoLpYuatgbgYlU/mMB4JXQ4aA50WZ2BHtt3I=";
    }
    {
      url = "${baseurl}/smlnj-c.tgz";
      hash = "sha256-Vure6h0TKqne5+5MJBX9cRkBgmrJ/kKVLUzrIIiH7lE=";
    }
    {
      url = "${baseurl}/doc.tgz";
      hash = "sha256-PliWxCffISPrAO7Zan33recFLRmGoqZLKHOzSEP0PEk=";
    }
    {
      url = "${baseurl}/asdl.tgz";
      hash = "sha256-O6/g20/hsMTG3CvMA59btjG+4UdUbGhMHkizESKJDEA=";
    }
  ];
in
stdenv.mkDerivation {
  pname = "smlnj";
  inherit version sources;

  unpackPhase = ''
    for s in $sources; do
      b=$(basename $s)
      cp $s ''${b#*-}
    done
    unpackFile config.tgz
    mkdir base
    ./config/unpack $TMP runtime
  '';

  patchPhase =
    ''
      sed -i '/^PATH=/d' config/_arch-n-opsys base/runtime/config/gen-posix-names.sh
      echo SRCARCHIVEURL="file:/$TMP" > config/srcarchiveurl
    ''
    + lib.optionalString stdenv.hostPlatform.isDarwin ''
      # Locate standard headers like <unistd.h>
      substituteInPlace base/runtime/config/gen-posix-names.sh \
        --replace "\$SDK_PATH/usr" "${Libsystem}"
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

  meta = {
    description = "Standard ML of New Jersey, a compiler";
    homepage = "http://smlnj.org";
    license = lib.licenses.bsd3;
    platforms = [
      "x86_64-linux"
      "i686-linux"
      "x86_64-darwin"
    ];
    maintainers = with lib.maintainers; [
      skyesoss
      thoughtpolice
    ];
    mainProgram = "sml";
    # never built on x86_64-darwin since first introduction in nixpkgs
    broken = stdenv.hostPlatform.isDarwin && stdenv.hostPlatform.isx86_64;
  };
}
