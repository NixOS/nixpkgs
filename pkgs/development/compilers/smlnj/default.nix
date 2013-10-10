{ stdenv, fetchurl }:
let
  version = "110.76";
  baseurl = "http://smlnj.cs.uchicago.edu/dist/working/${version}";

  sources = map fetchurl [
    { url = "${baseurl}/config.tgz";              sha256 = "0mx5gib1jq5hl3j6gvkkfh60x2hx146xiisclaz4jgy452ywikj1"; }
    { url = "${baseurl}/cm.tgz";                  sha256 = "14y1pqqw5p5va3rvpk2jddx2gcm37z5hwp5zdm43z02afscq37jk"; }
    { url = "${baseurl}/compiler.tgz";            sha256 = "10gn7cwqzbnh4k3l6brb9hp59k9vz2m9fcaarv2fw1gilfw5a9rj"; }
    { url = "${baseurl}/runtime.tgz";             sha256 = "0zqajizayzrlrxm47q492mqgfxya7rwqrq4faafai8qfwga6q27n"; }
    { url = "${baseurl}/system.tgz";              sha256 = "0dys0f0cdgnivk1niam9g736c3mzrjf9r29051g0579an8yi8slg"; }
    { url = "${baseurl}/MLRISC.tgz";              sha256 = "00n1zk65cwf2kf669mn09lp0ya6bfap1czhyq0nfza409vm4v54x"; }
    { url = "${baseurl}/smlnj-lib.tgz";           sha256 = "1mx1vjxbpfgcq6fkmh2qirjfqzn3wcnjf4a9ijr7k2bwgnh99sc1"; }
    { url = "${baseurl}/ckit.tgz";                sha256 = "1fqdxs2cgzffj0i9rmzv1aljwnhx98hyvj3c2kivw3ligxp4wly4"; }
    { url = "${baseurl}/nlffi.tgz";               sha256 = "08dmvs95xmbas3hx7n0csxxl0d0bmhxg7gav1ay02gy9n8iw3g87"; }
    { url = "${baseurl}/cml.tgz";                 sha256 = "1qc1hs2k2xmn03ldyz2zf0pzbryd1n4bwix226ch8z9pnfimglyb"; }
    { url = "${baseurl}/eXene.tgz";               sha256 = "01z69rgmshh694wkcwrzi72z5d5glpijj7mqxb17yz106xyzmgim"; }
    { url = "${baseurl}/ml-lpt.tgz";              sha256 = "13gw4197ivzvd6qcbg5pzclhv1f2jy2c433halh021d60qjv4w4r"; }
    { url = "${baseurl}/ml-lex.tgz";              sha256 = "0sqa533zca1l7p79qhkb7lspvhk4k2r3839745sci32fzwy1804x"; }
    { url = "${baseurl}/ml-yacc.tgz";             sha256 = "1kzi0dpybd9hkklk460mgbwfkixjhav225kkmwnk3jxby3zgflci"; }
    { url = "${baseurl}/ml-burg.tgz";             sha256 = "0kjrba8l0v6jn3g6gv9dvrklpvxx9x57b7czwnrrd33pi28sv7fm"; }
    { url = "${baseurl}/pgraph.tgz";              sha256 = "174n22m7zibgk68033qql86kyk6mxjni4j0kcadafs0g2xmh6i6z"; }
    { url = "${baseurl}/trace-debug-profile.tgz"; sha256 = "1pq4wwx5ad7zx1306ka06lqwnjv446zz6ndpq6s9ak6ha79f2s9p"; }
    { url = "${baseurl}/heap2asm.tgz";            sha256 = "0p91fzwkfr7hng7c026gy5ggl5l9isxpm007iq6ivpjrfjy547wc"; }
    { url = "${baseurl}/smlnj-c.tgz";             sha256 = "0vra4gi91w0cjsw3rm162hgz5xsqbr7yds44q7zhs27kccsirpqc"; }
    { url = "${baseurl}/boot.x86-unix.tgz";       sha256 = "0qcvdhlvpr02c1ssk4jz6175lb9pkdg7zrfscqz6f7crnsgmc5nx"; }
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

    for i in $out/bin/*; do
      sed -i "2iSMLNJ_HOME=$out/" $i
    done
  '';

  meta = {
    description = "Standard ML of New Jersey, a compiler";
    homepage = http://smlnj.org;
    license = stdenv.lib.licenses.bsd3;
  };
}
