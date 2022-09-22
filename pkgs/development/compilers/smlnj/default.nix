{ lib, stdenv, fetchurl, Libsystem }:
let
  version = "110.99.3";
  baseurl = "http://smlnj.cs.uchicago.edu/dist/working/${version}";

  arch = if stdenv.is64bit
    then "64"
    else "32";

  boot32 = { url = "${baseurl}/boot.x86-unix.tgz";
             sha256 = "1id0ymxispdfspm10g4d1l3jc15hp3l8zm9y6qcw39cd4pibj5rm"; };
  boot64 = { url = "${baseurl}/boot.amd64-unix.tgz";
             sha256 = "00v6n7wkm9s2ldica9h85z7hcrbvdpii9h0raqbgxniljhx4fr1l"; };

  bootBinary = if stdenv.is64bit
               then boot64
               else boot32;

  sources = map fetchurl [
    bootBinary
    { url = "${baseurl}/config.tgz";              sha256 = "15s18kg5bq0hfl9lwlrp845qqvg6s124ankbcsr18hf8c7s68hn0"; }
    { url = "${baseurl}/cm.tgz";                  sha256 = "0yw4ff1v1lbzg2xv8n1r56ik8x57q0z0rm3d0r62msahqf7fv7s9"; }
    { url = "${baseurl}/compiler.tgz";            sha256 = "1fjgrz8ar9nci55k7bfz0i49w4gqgg0g7w26pwfzhz8icq5y0a6l"; }
    { url = "${baseurl}/runtime.tgz";             sha256 = "080pa8m8s017mv3r1q9z34i011f895rnzj115z8miw1a17ba2bsd"; }
    { url = "${baseurl}/system.tgz";              sha256 = "1bc6cjc0l7sd6dal3l0kjipph6c2kgm8xn9gj0a2kzz3r4gyb96j"; }
    { url = "${baseurl}/MLRISC.tgz";              sha256 = "0d059vchzbk8xmhd2hsh0vds00p0x7wg9w8wk6jx0x4sjhf10xsn"; }
    { url = "${baseurl}/smlnj-lib.tgz";           sha256 = "1ig1v1hr8h8rbfiynsgkimmnwpbfgl48zwi9hhl9hqbcfiax1g65"; }
    { url = "${baseurl}/old-basis.tgz";           sha256 = "0ikb2j61r11xym6i9cwfrc63x16sq1c59cnqh8nhj62bb3rnjaq0"; }
    { url = "${baseurl}/ckit.tgz";                sha256 = "1rdjf6sk5rw9y3n14x3mvnmjhrbn5qjvizy2lrsx1yzagd41854b"; }
    { url = "${baseurl}/nlffi.tgz";               sha256 = "0qrgzpm74wh089avw17w8afyj8chfl84y9mkd653vkn9744cyk8m"; }
    { url = "${baseurl}/cml.tgz";                 sha256 = "0lkpzzzh66yg21745v0wzb7bwr83z3swdd09rad5nfmx5zk2r9w3"; }
    { url = "${baseurl}/eXene.tgz";               sha256 = "120n3475m1hvipyn55l6169hgc5bzsgb8p0bi1mk1yylf77cj7lq"; }
    { url = "${baseurl}/ml-lpt.tgz";              sha256 = "12pp90yl0dxfp3a7373ba00fjvpbyy8mxfml5qfpqr8r04k4fx4k"; }
    { url = "${baseurl}/ml-lex.tgz";              sha256 = "1vmq99f98y5md5rab3qi4w6k9ar4jhsgvpyy1ml663jr6barfl4y"; }
    { url = "${baseurl}/ml-yacc.tgz";             sha256 = "0jbkih9dmkpzz1833blc10nbgnkd1w3b0xshq8z88208wza8m2i1"; }
    { url = "${baseurl}/ml-burg.tgz";             sha256 = "182a1p9vj2pf6ms6ysz26dc0p1gwnqiissn3wv8g7ysh3lyksllf"; }
    { url = "${baseurl}/pgraph.tgz";              sha256 = "0w8d2dsw94d0xb5kigz7mvnznapgl095n88f62zr288lg5f3094f"; }
    { url = "${baseurl}/trace-debug-profile.tgz"; sha256 = "0xpm07gcxbh0pypn7x7qb8030q9bz8nmh99k928vkrxrql4snw8x"; }
    { url = "${baseurl}/heap2asm.tgz";            sha256 = "0yc6d7gipr9i6x751j5rv1zcrhdwmwpyc6sk1fvnjpl9d1fzdwmg"; }
    { url = "${baseurl}/smlnj-c.tgz";             sha256 = "1zi4mw52hqin8y4j5x77b5ydc05n3aw6ayb034q9vbs3sj9lvzsd"; }
    { url = "${baseurl}/doc.tgz";                 sha256 = "08w45msvv1p8945ghsqsz418fvaxrvxacvaijfb54d2baqahnzss"; }
    { url = "${baseurl}/asdl.tgz";                sha256 = "02kh75l3scfs2rmznyir6fq7c9wkh8iw7n9p3545xf955qkbs5iy"; }
  ];
in stdenv.mkDerivation {
  pname = "smlnj";
  inherit version;

  inherit sources;

  postPatch = ''
    sed -i '/^PATH=/d' config/_arch-n-opsys base/runtime/config/gen-posix-names.sh
    echo SRCARCHIVEURL="file:/$TMP" > config/srcarchiveurl
    patch --verbose config/_heap2exec ${./heap2exec.diff}
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
  };
}
