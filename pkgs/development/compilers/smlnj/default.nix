{ stdenv, fetchurl, darwin }:
let
  version = "110.78";
  baseurl = "http://smlnj.cs.uchicago.edu/dist/working/${version}";

  sources = map fetchurl [
    { url = "${baseurl}/config.tgz";              sha256 = "018c6iflpm3im6679via1wshw2sls4jgiqrc30pqkb80kfrh1pg2"; }
    { url = "${baseurl}/cm.tgz";                  sha256 = "0id37j6lj4b3qczn4949gvc8hys9j3h7nk9kc9fxv4rv1g7i328x"; }
    { url = "${baseurl}/compiler.tgz";            sha256 = "1m299lzc8l9mixb2l9scvilz27v16db3igzwca19alsrvldnmpg2"; }
    { url = "${baseurl}/runtime.tgz";             sha256 = "1pwbv1bnh8dz4w62cx19c56z4y57krbpr1ziayyycg7lj44pb7sy"; }
    { url = "${baseurl}/system.tgz";              sha256 = "1jdilm3wcjxcnnbd3g8rcd1f5nsb5ffzfjqcsdcpqd9mnx81fca9"; }
    { url = "${baseurl}/MLRISC.tgz";              sha256 = "0ibqwkkqd4c62p3q1jbgqyh7k78sms01igl7ibk6jyrhy9n7vw0v"; }
    { url = "${baseurl}/smlnj-lib.tgz";           sha256 = "1lxnwp8q3xw0wqqrv3hlk3fjancrfz862fy9j504s38ljhdjc3jr"; }
    { url = "${baseurl}/ckit.tgz";                sha256 = "1nqw40vjxy40ckif5d480g5mf7b91lmwcs7m689gs9n2dj3gbwnp"; }
    { url = "${baseurl}/nlffi.tgz";               sha256 = "1cks1xifb32wya2flw7h7cvcdnkxv7ngk8y7xv29888r7xbdr3h0"; }
    { url = "${baseurl}/cml.tgz";                 sha256 = "0qfaj6vsagsnh9di94cxvn77f91zfwsnn95rz8ig5dz5zmq77ghz"; }
    { url = "${baseurl}/eXene.tgz";               sha256 = "1nlkb2y48m702qplxkqphvb9nbj433300j7yrdbsj39j6vvp8pmw"; }
    { url = "${baseurl}/ml-lpt.tgz";              sha256 = "02b2gdl1qdwilhls3ssa04wcyg3aswndn1bh85008rqj85ppddiq"; }
    { url = "${baseurl}/ml-lex.tgz";              sha256 = "0l1sddd5wfpqgmyw1g3iwv2p27fbkpjkm10db2qd2pid9r95dxz5"; }
    { url = "${baseurl}/ml-yacc.tgz";             sha256 = "0ln790ydb43sxbjjymbd6jnnzfygrc0lr50k81p5cazzzy1yfim6"; }
    { url = "${baseurl}/ml-burg.tgz";             sha256 = "03anyy2gdkgfprmahx489hxg9zjh9lydq3gkzrlyw51yzvgp3f92"; }
    { url = "${baseurl}/pgraph.tgz";              sha256 = "19hbcav11a6fv0xmzgin0v5dl4m08msk1vsmw26kpqiqkvkh7j39"; }
    { url = "${baseurl}/trace-debug-profile.tgz"; sha256 = "0awssg3vgj3sp85kdfjcp28zaq815zr55k9z6v79zs9gll02ghlk"; }
    { url = "${baseurl}/heap2asm.tgz";            sha256 = "1vkmxbm6x37l1wqvilvvw662pdvg6mkbvcfvya8ggsihz4c1z0jg"; }
    { url = "${baseurl}/smlnj-c.tgz";             sha256 = "08b8acd5vwhz1gg7960rha00qhwk7l7p01vvgwzmdiqlcd3fcj1d"; }
    { url = "${baseurl}/doc.tgz";                 sha256 = "1pbsvc8nmnjwq239wrylb209drr4xv9a66r0fjm126b6nw1slrbq"; }
    { url = "${baseurl}/boot.x86-unix.tgz";       sha256 = "19wd273k4ldnxndq6cqr7xv387ynbviz6jlgxmlld7nxf549kn5a"; }
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
\    INCLFILE=${osx_sdk}/Developer/SDKs/${osx_sdk.name}/usr/include/unistd.h\
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
