{ stdenv, fetchurl, darwin }:
let
  version = "110.79";
  baseurl = "http://smlnj.cs.uchicago.edu/dist/working/${version}";

  sources = map fetchurl [
    { url = "${baseurl}/config.tgz";              sha256 = "1siahy5sxz20bdy88s7zjj6gn55np1h54dalmg0nwzqq1rc048xb"; }
    { url = "${baseurl}/cm.tgz";                  sha256 = "174g71hvk1wfdmrg1mbx3p5j04ywnbbjapnnr9sgjd99pqqqsmdz"; }
    { url = "${baseurl}/compiler.tgz";            sha256 = "001wi97ghj3mym4bk73gzzzrh7584hd79jn08cnq1wssdcfpn4mw"; }
    { url = "${baseurl}/runtime.tgz";             sha256 = "0lavdzg25nbdzdyyf6wm304k0gsbb5bng2nlcx8gcfl743vl13r0"; }
    { url = "${baseurl}/system.tgz";              sha256 = "00j34m5n8m30p51kajd0sxamy7gpwxaxrlgw5agxh0wi83vqfaki"; }
    { url = "${baseurl}/MLRISC.tgz";              sha256 = "19q3gp7yfby4n8z6jn9m9q8g0a9kvb13arj8f2j0x9jnh3y2is78"; }
    { url = "${baseurl}/smlnj-lib.tgz";           sha256 = "0frkc23zh9h1c2lvkidh92lsp56liyb3hyv17503nchmkxrlsi09"; }
    { url = "${baseurl}/old-basis.tgz";           sha256 = "1ka7w4nvkmaf86dkdzgbwiw8kay6gxhcyx4q17m33wdzsjbq56lh"; }
    { url = "${baseurl}/ckit.tgz";                sha256 = "1z8xf5pqwayqd8j6xhfhqs4axkb4dx7vdqi2a7gq3zbx2fd3s7pw"; }
    { url = "${baseurl}/nlffi.tgz";               sha256 = "1544m7ildyd0d60wfy2hl700jnslpxqb7brgh8p0bmkvhhvvc96v"; }
    { url = "${baseurl}/cml.tgz";                 sha256 = "11blq65zlsbh6iwq502jww1z4iyk9pf2iv3d437cgnpb3sn9mx72"; }
    { url = "${baseurl}/eXene.tgz";               sha256 = "14yl8a5xwms1m9bvfwfiz6rhg49225l52lqqq9sbxbf57615n9yg"; }
    { url = "${baseurl}/ml-lpt.tgz";              sha256 = "118s7v2f73ym91ymvnmswjxm2pw5n4q1d4hvbs1cmm43dv28pw7m"; }
    { url = "${baseurl}/ml-lex.tgz";              sha256 = "0lf5ir12v8j6n11mblrl00jgm583ak077vgbabc1dfmz47rd566b"; }
    { url = "${baseurl}/ml-yacc.tgz";             sha256 = "0dmifbbq1wxkxf479jv61nsy79sr78ad9fq6561rvgi4h12lzh7k"; }
    { url = "${baseurl}/ml-burg.tgz";             sha256 = "1b5z18azik1kpaafi1vjgaf181yv32h88zm3z5fqxs96pwb86h1d"; }
    { url = "${baseurl}/pgraph.tgz";              sha256 = "15g06hl7zn98qas3b6r6lrl75g9d1galqxdyai7d5z9q5lq71j2v"; }
    { url = "${baseurl}/trace-debug-profile.tgz"; sha256 = "0jwilcv2ycfpcy3cgs8ndaj16yqm8m2q63sipcigfycacpyqfsiw"; }
    { url = "${baseurl}/heap2asm.tgz";            sha256 = "0wylsw1dkls9l86j226ilfb50mfk4h4zz4r9zdj104a1mqvvbgfk"; }
    { url = "${baseurl}/smlnj-c.tgz";             sha256 = "1xr89r1nhzg53hk0v0fk1livphwpgmzh1dgjqxl4w8dx9qhk9yf0"; }
    { url = "${baseurl}/doc.tgz";                 sha256 = "1fz4l3019n1rkrww98w59cdhlrz9jg635hmdq59xryc0j78y4ga1"; }
    { url = "${baseurl}/boot.x86-unix.tgz";       sha256 = "0nka4dhklhilrsw4byr5vixiap28zp67ai0vjkwhqh03amkcr8zq"; }
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
\    INCLFILE=${apple_sdk.sdk}/include/unistd.h\
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
