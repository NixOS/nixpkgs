{ stdenv, fetchurl }:
let
  version = "110.91";
  baseurl = "http://smlnj.cs.uchicago.edu/dist/working/${version}";

  sources = map fetchurl [
    { url = "${baseurl}/config.tgz";              sha256 = "00vbg2kpwgkf272m697p5hd35pawficbrifchn7dnd519wpdx436"; }
    { url = "${baseurl}/cm.tgz";                  sha256 = "0wxb0s2fwh7lbb3z2pfvmvhk5v0gm75kchkv7gg9f895ahyvm6yd"; }
    { url = "${baseurl}/compiler.tgz";            sha256 = "0iq06ycivy562i59vvbma9zi575zw1djhdfkcy0bn7m9kfzzbgkh"; }
    { url = "${baseurl}/runtime.tgz";             sha256 = "0km8p4vmy3m38xv0rl8d3mh2nlk2mvx010npm34gs374bmmzc7z9"; }
    { url = "${baseurl}/system.tgz";              sha256 = "16d5vs1rn7ly6jxjm08222cj0sry73pr57xpc9d6k286b1v0910b"; }
    { url = "${baseurl}/MLRISC.tgz";              sha256 = "1c9sw8zm90ykas5nwbhk2wic7sxkjrylb610x37v46m5ips1wlma"; }
    { url = "${baseurl}/smlnj-lib.tgz";           sha256 = "09ka20ym7ahrpj4r6vc5phflc8y57dj09qvwk8ambfwb2p2274sw"; }
    { url = "${baseurl}/old-basis.tgz";           sha256 = "1bhq9fv6p8diz489h9571g0xrsi8yx7h6gh9410255klxjrw964h"; }
    { url = "${baseurl}/ckit.tgz";                sha256 = "1lq9ljai0shc6hszx5v6bqmkz16a3f295mfg7q622apzgzark3vd"; }
    { url = "${baseurl}/nlffi.tgz";               sha256 = "1xjmlwiclgckj73z5hz3hnqlavp3ax9sfvgc0rvj3xpy3i3n6axj"; }
    { url = "${baseurl}/cml.tgz";                 sha256 = "1sjzipxnvr9dgcg16bllfk3b46ac9f8h353nh1ccykwwq4whi9bf"; }
    { url = "${baseurl}/eXene.tgz";               sha256 = "04clbchrlqx5v35gkbydbfnpl720i4nqijkshiwn0v592n4xfdf4"; }
    { url = "${baseurl}/ml-lpt.tgz";              sha256 = "0max073nzwv7vx13caj7zmlhslvxlgg8rj52278g7f6fqcrwp5cf"; }
    { url = "${baseurl}/ml-lex.tgz";              sha256 = "0x2mbg45l71049sgvvkl6bnqc5svz70vh1m1rbf3xk41z5bapcgr"; }
    { url = "${baseurl}/ml-yacc.tgz";             sha256 = "0a1pbwpw1y6d1xn9yjarqpmybrxqwp5snp28by36745h1jvb1p1b"; }
    { url = "${baseurl}/ml-burg.tgz";             sha256 = "119mq5jrbkn9vf9fgb0wyz483hf26al9hwb91xpmlmfx5qqnfzik"; }
    { url = "${baseurl}/pgraph.tgz";              sha256 = "1s7jmh3q88rz29bk02y3gzdqrgvk484j5ji8bn7s6fc78m50nqp8"; }
    { url = "${baseurl}/trace-debug-profile.tgz"; sha256 = "1gzf1pbmw2cn5w6f5qfdm3d6n6069n1nnzz6z4v7mr07x54c6mdv"; }
    { url = "${baseurl}/heap2asm.tgz";            sha256 = "09cgj568a9x017awysjdx35mlp5zkdmc2fs67fvnm5ifl7ivfs8j"; }
    { url = "${baseurl}/smlnj-c.tgz";             sha256 = "1g4xhcxychs9q25x7a5lvqfamq52c5ljlx84bc5cazvpkhixyg04"; }
    { url = "${baseurl}/doc.tgz";                 sha256 = "1l0x91dscizk2pyj1lw595r84h1h0shxh0x5hva891717a1hfa51"; }
    { url = "${baseurl}/boot.x86-unix.tgz";       sha256 = "0f6x4nfhrgm1z4dx862df2yaffdh1sd6zx2lyb2vph5mhp7x9n58"; }
    { url = "${baseurl}/asdl.tgz";                sha256 = "1pi3m21jllyd2h0zpz4bajskfv58g6pjhpprqiwgmikn6w1pryp8"; }
  ];
in stdenv.mkDerivation {
  name = "smlnj-${version}";

  inherit sources;

  patchPhase = ''
    sed -i '/PATH=/d' config/_arch-n-opsys base/runtime/config/gen-posix-names.sh
    echo SRCARCHIVEURL="file:/$TMP" > config/srcarchiveurl
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
    platforms   = [ "i686-linux" ];
    maintainers = with maintainers; [ thoughtpolice ];
  };
}
