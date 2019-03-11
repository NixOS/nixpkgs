{ stdenv, fetchurl, darwin }:
let
  version = "110.85";
  baseurl = "http://smlnj.cs.uchicago.edu/dist/working/${version}";

  sources = map fetchurl [
    { url = "${baseurl}/config.tgz";              sha256 = "1qlir3q0vi7f1wyz2jyaiqy3z72d0xngsa122ks5g0b7b0hcdgm1"; }
    { url = "${baseurl}/cm.tgz";                  sha256 = "0330jkmaxgy085hsgajqikm242gms650rks24mfxhgk11r4ks105"; }
    { url = "${baseurl}/compiler.tgz";            sha256 = "1zrqqvi9332g3clrh01z19sl06g3zlnp6zzz5z8rvsfwbiqp929m"; }
    { url = "${baseurl}/runtime.tgz";             sha256 = "1n9hd99s2i834yihx4n59gl1cnh7hiiz8im735bmifmv50vzfdf4"; }
    { url = "${baseurl}/system.tgz";              sha256 = "17samia4lzcz3mk73i330bspap2ks937arx35n9dr7bws0appfm8"; }
    { url = "${baseurl}/MLRISC.tgz";              sha256 = "039g6dwxy96bkvw1z19vwn8q150h7s8jlcmsg851bgz3j3h6vs18"; }
    { url = "${baseurl}/smlnj-lib.tgz";           sha256 = "1wk4w1npipm6qqgwis2xrbdjamwmiwv6ci4y40nzryhb37yxfj6d"; }
    { url = "${baseurl}/old-basis.tgz";           sha256 = "0lkhbkkglz7lk1c93hc1y1di5dx20fgfhybvsqjp1bcwz8jsd70y"; }
    { url = "${baseurl}/ckit.tgz";                sha256 = "14qxgw2vhq4dfiv5zl2gdhvjp75s10dqw97mqxffmh3vayyad1fi"; }
    { url = "${baseurl}/nlffi.tgz";               sha256 = "16l8iszkyh34dqdbplsxycipvbw61yjamgxllcq8axiq4h7spy7w"; }
    { url = "${baseurl}/cml.tgz";                 sha256 = "05dlqz4r3qa3rpqgjlx91fsfx7j6gk3dkw28zcgg5g32irmd1la3"; }
    { url = "${baseurl}/eXene.tgz";               sha256 = "07mahzxns26hkfax9gc8cq4s8sfzj531wwnm47b8qkhd72d3ncn2"; }
    { url = "${baseurl}/ml-lpt.tgz";              sha256 = "0073hfn98l61ryshhqw9855fb49vs9qcz9nplbg2pa2f7manqbk0"; }
    { url = "${baseurl}/ml-lex.tgz";              sha256 = "106km17f4wyvhzkx62cfq2gp4ihya8l234550laqb50zf8vxyklq"; }
    { url = "${baseurl}/ml-yacc.tgz";             sha256 = "1r0k7lz8xnir271pykbs4agadysbs35kkmg1p816kzfyz5bsrrq9"; }
    { url = "${baseurl}/ml-burg.tgz";             sha256 = "10jqasplbxp50ryq74aazbnyaz8l492rhdij5mr1kzyfj79fysh9"; }
    { url = "${baseurl}/pgraph.tgz";              sha256 = "1pxqddbrb7y9kp89gz8v8vfjmw4wajfy6757gb8c6x499jarxa60"; }
    { url = "${baseurl}/trace-debug-profile.tgz"; sha256 = "0fkalpdzdrm1gmafn33ck4dw8s92p9iwm4fav4m9jcqyha9az3g7"; }
    { url = "${baseurl}/heap2asm.tgz";            sha256 = "056gkmrylyrf0q0r3cpx76zx8mc62033jkn1bnjn0f8r31yhbipc"; }
    { url = "${baseurl}/smlnj-c.tgz";             sha256 = "04c4jnylj5dnd4sjywzwnqlv9g7dkrilq6d4cy543dw03yhjdykw"; }
    { url = "${baseurl}/doc.tgz";                 sha256 = "1rpk9g1nhjpc2b4pmzmj8v80knrhljn17ghiwznnljv53hka7jzx"; }
    { url = "${baseurl}/boot.x86-unix.tgz";       sha256 = "05rh1y74jvp6zs96mb7nkwbgwwbss0zy2iw4gicdkyf6in0nk4la"; }
    { url = "${baseurl}/asdl.tgz";                sha256 = "1d465bncgy92ni6430dbq6isvnysfhvykjrxm98dz82iih7a6vqb"; }
  ];
in stdenv.mkDerivation {
  name = "smlnj-${version}";

  inherit sources;

  patchPhase = ''
    sed -i '/PATH=/d' config/_arch-n-opsys base/runtime/config/gen-posix-names.sh
    echo SRCARCHIVEURL="file:/$TMP" > config/srcarchiveurl
  '' + stdenv.lib.optionalString stdenv.isDarwin (with darwin; ''
    sed -i '/^[[:space:]]*\*x86-darwin\*)$/,/^[[:space:]]*\*) ;;/ c\
\  \*x86-darwin\*)\
\    INCLFILE=${stdenv.lib.getDev apple_sdk.sdk}/include/unistd.h\
\    ;;\
\  \*) ;;
' base/runtime/config/gen-posix-names.sh
    sed -i 's|^AS =\([[:space:]]*\)/usr/bin/as|AS =\1as|' base/runtime/objs/mk.x86-darwin
  '');

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
    ./config/install.sh
  '';

  installPhase = ''
    mkdir -pv $out
    cp -rv bin lib $out

    cd $out/bin
    for i in *; do
      sed -i "2iSMLNJ_HOME=$out/" $i
    done
  '';

  meta = with stdenv.lib; {
    description = "Standard ML of New Jersey, a compiler";
    homepage    = http://smlnj.org;
    license     = licenses.bsd3;
    platforms   = [ "i686-linux" ] ++ platforms.darwin;
    maintainers = with maintainers; [ thoughtpolice ];
  };
}
