{ stdenv, fetchurl, darwin }:
let
  version = "110.84";
  baseurl = "http://smlnj.cs.uchicago.edu/dist/working/${version}";

  sources = map fetchurl [
    { url = "${baseurl}/config.tgz";              sha256 = "0cpqrvixqwf64fa94wzwf59p0lnnmwxgkwm3qwhf28l2fv5d640q"; }
    { url = "${baseurl}/cm.tgz";                  sha256 = "0qq6kdi8xqi3w1rsmi4rgjdbjr9m4crizb1ma5xg51x8h42ccmbh"; }
    { url = "${baseurl}/compiler.tgz";            sha256 = "11zfdwr7a10ylzvap2j0c1py11zi500hfnmhd5lvy9spwzray8vd"; }
    { url = "${baseurl}/runtime.tgz";             sha256 = "0v2dv0hh0gxnzzxz8vzqn5avxh7mynaj4g9kkbv4gcnxxaylpksz"; }
    { url = "${baseurl}/system.tgz";              sha256 = "0612a6qls202l6wbckcd6dklh7nb75fk4c4qmbs9h2h0j3kisszl"; }
    { url = "${baseurl}/MLRISC.tgz";              sha256 = "0wnhvy677p2f7pxlk8mmk3gi605nawy1zzn2cf4619wg04v54g6s"; }
    { url = "${baseurl}/smlnj-lib.tgz";           sha256 = "1pg9y0lcp18fc91y45yb2lysnrzml00xdhcilkc1cx17am394mik"; }
    { url = "${baseurl}/old-basis.tgz";           sha256 = "14zdkzfri4a7mj7zck2c43aqkg0y7kppp2nkbihg069g4ifgw5fg"; }
    { url = "${baseurl}/ckit.tgz";                sha256 = "0dlccmnchs38www0a3ibrjxipf8xi03d7pgriynjqdyjjgik89by"; }
    { url = "${baseurl}/nlffi.tgz";               sha256 = "0c9z2fq8d7ln4flzc5pkfym9rkjhjymjm60v1avh1c337lmai5lb"; }
    { url = "${baseurl}/cml.tgz";                 sha256 = "16jn5fn8khxnjj0kwjzavx2ms3kv16zy35wamh8k51nv8v3i0qam"; }
    { url = "${baseurl}/eXene.tgz";               sha256 = "1701l155aiprzxh5p5whb9qbg368cqq0bzdwkwsxgrrllfhwdq9z"; }
    { url = "${baseurl}/ml-lpt.tgz";              sha256 = "19dk9yqq6f5ayqlf7p95aakc4swj6x1j8m0ka2slzzb9g93f2q1g"; }
    { url = "${baseurl}/ml-lex.tgz";              sha256 = "0w20w17rd67n6zgxzwq89k9ywc78l3ydxcax0pniwzv6m5d08znc"; }
    { url = "${baseurl}/ml-yacc.tgz";             sha256 = "1fdxhy4f2dgs19p20vg7yysi9gxp6hc1ggs97k4zq448y2ssxsyg"; }
    { url = "${baseurl}/ml-burg.tgz";             sha256 = "066r0zy5rc60y8kzh2c06hy1b217lh6qffvxlwz8w1w86yqkgsk2"; }
    { url = "${baseurl}/pgraph.tgz";              sha256 = "1jy1g9xiv14jj9svb5wgbdm520qbdhamfmxlf31xnh552gg18bxa"; }
    { url = "${baseurl}/trace-debug-profile.tgz"; sha256 = "0nkawi2mdmsw24a1pkwp2brixrvxyqgxzsylp7w7ak35p20l5igc"; }
    { url = "${baseurl}/heap2asm.tgz";            sha256 = "159y8c8xnim7p4pyynjirqhwi73lkrq0fksk8wnpcdh5clmwacrx"; }
    { url = "${baseurl}/smlnj-c.tgz";             sha256 = "1sgfdnvkqa6wmwg027wg8lvg7zxq36p83bkymy8qkjdlxhxm2nhl"; }
    { url = "${baseurl}/doc.tgz";                 sha256 = "083h5h937gkhfq3xk982vmng903c83d98yh5fps53f62wib99mhf"; }
    { url = "${baseurl}/boot.x86-unix.tgz";       sha256 = "10nf79jzmv64ag8c11fxd9ggw21a9kdn9shqkiz1kni3lq63p7m2"; }
    { url = "${baseurl}/asdl.tgz";                sha256 = "13jvdgv63h4s8p9q563hyisbz464y88y2flvwyxvi1n11lh15rwb"; }
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
