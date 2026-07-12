{
  self,
  openssl,
}:

with self;

{

  ocaml-compiler-libs = janePackage {
    pname = "ocaml-compiler-libs";
    hash = "0g9y1ljjsj1nw0lz460ivb6qmz9vhcmfl8krlmqfrni6pc7b0r6f";
    meta.description = "OCaml compiler libraries repackaged";
  };

  sexplib0 = janePackage {
    pname = "sexplib0";
    hash = "13xdd0pvypxqn0ldwdgikmlinrp3yfh8ixknv1xrpxbx3np4qp0g";
    meta.description = "Library containing the definition of S-expressions and some base converters";
  };

  base = janePackage {
    pname = "base";
    version = "0.12.2";
    hash = "0gl89zpgsf3n30nb6v5cns27g2bfg4rf3s2427gqvwbkr5gcf7ri";
    meta.description = "Full standard library replacement for OCaml";
    propagatedBuildInputs = [ sexplib0 ];
    buildInputs = [ dune-configurator ];
  };

  stdio = janePackage {
    pname = "stdio";
    hash = "1pn8jjcb79n6crpw7dkp68s4lz2mw103lwmfslil66f05jsxhjhg";
    meta.description = "Standard IO library for OCaml";
    propagatedBuildInputs = [ base ];
  };

  ppx_sexp_conv = janePackage {
    pname = "ppx_sexp_conv";
    hash = "0idzp1kzds0gnilschzs9ydi54if8y5xpn6ajn710vkipq26qcld";
    meta.description = "[@@deriving] plugin to generate S-expression conversion functions";
    propagatedBuildInputs = [ ppxlib ];
  };

  ppx_here = janePackage {
    pname = "ppx_here";
    hash = "07qbchwif1i9ii8z7v1bib57d3mjv0b27i8iixw78i83wnsycmdx";
    meta.description = "Expands [%here] into its location";
    propagatedBuildInputs = [ ppxlib ];
  };

  ppx_compare = janePackage {
    pname = "ppx_compare";
    hash = "0n1ax4k2smhps9hc2v58lc06a0fgimwvbi1aj4x78vwh5j492bys";
    meta.description = "Generation of comparison functions from types";
    propagatedBuildInputs = [ ppxlib ];
  };

  ppx_assert = janePackage {
    pname = "ppx_assert";
    hash = "0as6mzr6ki2a9d4k6132p9dskn0qssla1s7j5rkzp75bfikd0ip8";
    meta.description = "Assert-like extension nodes that raise useful errors on failure";
    propagatedBuildInputs = [
      ppx_compare
      ppx_here
      ppx_sexp_conv
    ];
  };

  ppx_inline_test = janePackage {
    pname = "ppx_inline_test";
    hash = "0nyz411zim94pzbxm2l2v2l9jishcxwvxhh142792g2s18r4vn50";
    meta.description = "Syntax extension for writing in-line tests in ocaml code";
    propagatedBuildInputs = [ ppxlib ];
  };

  ppx_custom_printf = janePackage {
    pname = "ppx_custom_printf";
    version = "0.12.1";
    hash = "0q7591agvd3qy9ihhbyk4db48r0ng7yxspfj8afxxiawl7k5bas6";
    meta.description = "Printf-style format-strings for user-defined string conversion";
    propagatedBuildInputs = [ ppx_sexp_conv ];
  };

  fieldslib = janePackage {
    pname = "fieldslib";
    hash = "0dlgr7cimqmjlcymk3bdcyzqzvdy12q5lqa844nqix0k2ymhyphf";
    meta.description = "Syntax extension to define first class values representing record fields, to get and set record fields, iterate and fold over all fields of a record and create new record values";
    propagatedBuildInputs = [ base ];
  };

  ppx_fields_conv = janePackage {
    pname = "ppx_fields_conv";
    hash = "0flrdyxdfcqcmdrbipxdjq0s3djdgs7z5pvjdycsvs6czbixz70v";
    meta.description = "Generation of accessor and iteration functions for ocaml records";
    propagatedBuildInputs = [
      fieldslib
      ppxlib
    ];
  };

  variantslib = janePackage {
    pname = "variantslib";
    hash = "1cclb5magk63gyqmkci8abhs05g2pyhyr60a2c1bvmig0faqcnsf";
    meta.description = "Part of Jane Street's Core library";
    propagatedBuildInputs = [ base ];
  };

  ppx_variants_conv = janePackage {
    pname = "ppx_variants_conv";
    hash = "05j9bgra8xq6fcp12ch3z9vjrk139p2wrcjjcs4h52n5hhc8vzbz";
    meta.description = "Generation of accessor and iteration functions for ocaml variant types";
    propagatedBuildInputs = [
      variantslib
      ppxlib
    ];
  };

  ppx_expect = janePackage {
    pname = "ppx_expect";
    hash = "1wawsbjfkri4sw52n8xqrzihxc3xfpdicv3ahz83a1rsn4lb8j5q";
    meta.description = "Cram like framework for OCaml";
    propagatedBuildInputs = [
      ppx_assert
      ppx_custom_printf
      ppx_fields_conv
      ppx_inline_test
      ppx_variants_conv
      re
    ];
  };

  ppx_enumerate = janePackage {
    pname = "ppx_enumerate";
    hash = "08zfpq6bdm5lh7xj9k72iz9f2ihv3aznl3nypw3x78vz1chj8dqa";
    meta.description = "Generate a list containing all values of a finite type";
    propagatedBuildInputs = [ ppxlib ];
  };

  ppx_hash = janePackage {
    pname = "ppx_hash";
    hash = "1dfsfvhiyp1mnf24mr93svpdn432kla0y7x631lssacxxp2sadbg";
    meta.description = "PPX rewriter that generates hash functions from type expressions and definitions";
    propagatedBuildInputs = [
      ppx_compare
      ppx_sexp_conv
    ];
  };

  ppx_js_style = janePackage {
    pname = "ppx_js_style";
    hash = "1lz931m3qdv3yzqy6dnb8fq1d99r61w0n7cwf3b9fl9rhk0pggwh";
    meta.description = "Code style checker for Jane Street Packages";
    propagatedBuildInputs = [
      octavius
      ppxlib
    ];
  };

  ppx_base = janePackage {
    pname = "ppx_base";
    hash = "0vd96rp2l084iamkwmvizzhl9625cagjb6gzzbir06czii5mlq2p";
    meta.description = "Base set of ppx rewriters";
    propagatedBuildInputs = [
      ppx_enumerate
      ppx_hash
      ppx_js_style
    ];
  };

  ppx_bench = janePackage {
    pname = "ppx_bench";
    hash = "1ib81irawxzq091bmpi50z0kmpx6z2drg14k2xcgmwbb1d4063xn";
    meta.description = "Syntax extension for writing in-line benchmarks in ocaml code";
    propagatedBuildInputs = [ ppx_inline_test ];
  };

  ppx_sexp_message = janePackage {
    pname = "ppx_sexp_message";
    hash = "0yskd6v48jc6wa0nhg685kylh1n9qb6b7d1wglr9wnhl9sw990mc";
    meta.description = "PPX rewriter for easy construction of s-expressions";
    propagatedBuildInputs = [
      ppx_here
      ppx_sexp_conv
    ];
  };

  splittable_random = janePackage {
    pname = "splittable_random";
    hash = "1wpyz7807cgj8b50gdx4rw6f1zsznp4ni5lzjbnqdwa66na6ynr4";
    meta.description = "PRNG that can be split into independent streams";
    propagatedBuildInputs = [
      base
      ppx_assert
      ppx_bench
      ppx_sexp_message
    ];
  };

  ppx_let = janePackage {
    pname = "ppx_let";
    hash = "146dmyzkbmafa3giz69gpxccvdihg19cvk4xsg8krbbmlkvdda22";
    meta.description = "Monadic let-bindings";
    propagatedBuildInputs = [ ppxlib ];
  };

  base_quickcheck = janePackage {
    version = "0.12.1";
    pname = "base_quickcheck";
    hash = "sha256-ABfUtOzdtGrYR6EgtVYkmxRvsH48jJwSVVOwf4Od12Y=";
    meta.description = "Randomized testing framework, designed for compatibility with Base";
    propagatedBuildInputs = [
      ppx_base
      ppx_fields_conv
      ppx_let
      splittable_random
    ];
  };

  ppx_stable = janePackage {
    pname = "ppx_stable";
    hash = "15zvf66wlkvz0yd4bkvndkpq74dj20jv1qkljp9n52hh7d0f9ykh";
    meta.description = "Stable types conversions generator";
    propagatedBuildInputs = [ ppxlib ];
  };

  bin_prot = janePackage {
    pname = "bin_prot";
    hash = "0hh6s7g9s004z35hsr8z6nw5phlcvcd6g2q3bj4f0s1s0anlsswm";
    meta.description = "Binary protocol generator";
    propagatedBuildInputs = [
      ppx_compare
      ppx_custom_printf
      ppx_fields_conv
      ppx_variants_conv
    ];
  };

  ppx_bin_prot = janePackage {
    pname = "ppx_bin_prot";
    version = "0.12.1";
    hash = "1j0kjgmv58dmg3x5dj5zrfbm920rwq21lvkkaqq493y76cd0x8xg";
    meta.description = "Generation of bin_prot readers and writers from types";
    propagatedBuildInputs = [
      bin_prot
      ppx_here
    ];
  };

  ppx_fail = janePackage {
    pname = "ppx_fail";
    hash = "0krsv6z9gi0ifxmw5ss6gwn108qhywyhbs41an10x9d5zpgf4l1n";
    meta.description = "Add location to calls to failwiths";
    propagatedBuildInputs = [ ppx_here ];
  };

  jst-config = janePackage {
    pname = "jst-config";
    hash = "0yxcz13vda1mdh9ah7qqxwfxpcqang5sgdssd8721rszbwqqaw93";
    meta.description = "Compile-time configuration for Jane Street libraries";
    buildInputs = [
      dune-configurator
      ppx_assert
    ];
  };

  ppx_optcomp = janePackage {
    pname = "ppx_optcomp";
    hash = "0bdbx01kz0174g1szdhv3mcfqxqqf2frxq7hk13xaf6fsz04kwmj";
    meta.description = "Optional compilation for OCaml";
    propagatedBuildInputs = [ ppxlib ];
  };

  jane-street-headers = janePackage {
    pname = "jane-street-headers";
    hash = "0qa4llf812rjqa8nb63snmy8d8ny91p3anwhb50afb7vjaby8m34";
    meta.description = "Jane Street C header files";
  };

  time_now = janePackage {
    pname = "time_now";
    hash = "169mgsb3rja4j1j9nj5xa7bbkd21p9kfpskqz0wjf9x2fpxqsniq";
    meta.description = "Reports the current time";
    buildInputs = [
      jst-config
      ppx_optcomp
    ];
    propagatedBuildInputs = [
      jane-street-headers
      base
      ppx_base
    ];
  };

  ppx_module_timer = janePackage {
    pname = "ppx_module_timer";
    hash = "0yziakm7f4c894na76k1z4bp7azy82xc33mh36fj761w1j9zy3wm";
    meta.description = "Ppx rewriter that records top-level module startup times";
    propagatedBuildInputs = [ time_now ];
  };

  ppx_optional = janePackage {
    pname = "ppx_optional";
    hash = "07i0iipbd5xw2bc604qkwlcxmhncfpm3xmrr6svyj2ij86pyssh8";
    meta.description = "Pattern matching on flat options";
    propagatedBuildInputs = [ ppxlib ];
  };

  ppx_pipebang = janePackage {
    pname = "ppx_pipebang";
    hash = "1p4pdpl8h2bblbhpn5nk17ri4rxpz0aih0gffg3cl1186irkj0xj";
    meta.description = "PPX rewriter that inlines reverse application operators `|>` and `|!`";
    propagatedBuildInputs = [ ppxlib ];
  };

  ppx_sexp_value = janePackage {
    pname = "ppx_sexp_value";
    hash = "1mg81834a6dx1x7x9zb9wc58438cabjjw08yhkx6i386hxfy891p";
    meta.description = "PPX rewriter that simplifies building s-expressions from ocaml values";
    propagatedBuildInputs = [
      ppx_here
      ppx_sexp_conv
    ];
  };

  typerep = janePackage {
    pname = "typerep";
    hash = "1psl6gsk06a62szh60y5sc1s92xpmrl1wpw3rhha09v884b7arbc";
    meta.description = "Typerep is a library for runtime types";
    propagatedBuildInputs = [ base ];
  };

  ppx_typerep_conv = janePackage {
    pname = "ppx_typerep_conv";
    hash = "09vik6qma1id44k8nz87y48l9wbjhqhap1ar1hpfdfkjai1hrzzq";
    meta.description = "Generation of runtime types from type declarations";
    propagatedBuildInputs = [
      ppxlib
      typerep
    ];
  };

  ppx_jane = janePackage {
    pname = "ppx_jane";
    hash = "1a2602isqzsh640q20qbmarx0sc316mlsqc3i25ysv2kdyhh0kyw";
    meta.description = "Standard Jane Street ppx rewriters";
    propagatedBuildInputs = [
      base_quickcheck
      ppx_bench
      ppx_bin_prot
      ppx_expect
      ppx_fail
      ppx_module_timer
      ppx_optcomp
      ppx_optional
      ppx_pipebang
      ppx_sexp_value
      ppx_stable
      ppx_typerep_conv
    ];
  };

  base_bigstring = janePackage {
    pname = "base_bigstring";
    hash = "0rbgyg511847fbnxad40prz2dyp4da6sffzyzl88j18cxqxbh1by";
    meta.description = "String type based on [Bigarray], for use in I/O and C-bindings";
    propagatedBuildInputs = [ ppx_jane ];
  };

  parsexp = janePackage {
    pname = "parsexp";
    hash = "1974i9s2c2n03iffxrm6ncwbd2gg6j6avz5jsxfd35scc2zxcd4l";
    meta.description = "S-expression parsing library";
    propagatedBuildInputs = [
      base
      sexplib0
    ];
  };

  sexplib = janePackage {
    pname = "sexplib";
    hash = "0780klc5nnv0ij6aklzra517cfnfkjdlp8ylwjrqwr8dl9rvxza2";
    meta.description = "Library for serializing OCaml values to and from S-expressions";
    propagatedBuildInputs = [
      num
      parsexp
    ];
  };

  core_kernel = janePackage {
    pname = "core_kernel";
    version = "0.12.3";
    hash = "sha256-bDgxuOILAs4FYB8o92ysPHDdEzflZMsU/jk5hB9xfuc=";
    meta.description = "System-independent part of Core";
    buildInputs = [ jst-config ];
    propagatedBuildInputs = [
      base_bigstring
      sexplib
    ];
  };

  spawn = janePackage {
    pname = "spawn";
    version = "0.13.0";
    hash = "1w003k1kw1lmyiqlk58gkxx8rac7dchiqlz6ah7aj7bh49b36ppf";
    meta.description = "Spawning sub-processes";
    buildInputs = [ ppx_expect ];
  };

  core = janePackage {
    pname = "core";
    version = "0.12.3";
    hash = "1vmjqiafkg45hqfvahx6jnlaww1q4a4215k8znbgprf0qn3zymnj";
    meta.description = "System-independent part of Core";
    buildInputs = [ jst-config ];
    propagatedBuildInputs = [
      core_kernel
      spawn
    ];
  };

  async_kernel = janePackage {
    pname = "async_kernel";
    hash = "1d9illx7vvpblj1i2r9y0f2yff2fbhy3rp4hhvamq1n9n3lvxmh2";
    meta.description = "Monadic concurrency library";
    propagatedBuildInputs = [ core_kernel ];
  };

  protocol_version_header = janePackage {
    pname = "protocol_version_header";
    hash = "14vqhx3r84rlfhcjq52gxdqksckiaswlck9s47g7y2z1lsc17v7r";
    meta.description = "Protocol versioning";
    propagatedBuildInputs = [ core_kernel ];
  };

  async_rpc_kernel = janePackage {
    pname = "async_rpc_kernel";
    hash = "1znhqbzx4fp58i7dbcgyv5rx7difbhb5d8cbqzv96yqvbn67lsjk";
    meta.description = "Platform-independent core of Async RPC library";
    propagatedBuildInputs = [
      async_kernel
      protocol_version_header
    ];
  };

  async_unix = janePackage {
    pname = "async_unix";
    hash = "09h10rdyykbm88n6r9nb5a22mlb6vcxa04q6hvrcr0kys6qhhqmb";
    meta.description = "Monadic concurrency library";
    propagatedBuildInputs = [
      async_kernel
      core
    ];
  };

  async_extra = janePackage {
    pname = "async_extra";
    hash = "10j4mwlyqvf67yrp5dwd857llqjinpnnykmlzw2gpmks9azxk6mh";
    meta.description = "Monadic concurrency library";
    propagatedBuildInputs = [
      async_rpc_kernel
      async_unix
    ];
  };

  textutils = janePackage {
    pname = "textutils";
    hash = "0302awqihf3abib9mvzvn4g8m364hm6jxry1r3kc01hzybhy9acq";
    meta.description = "Text output utilities";
    propagatedBuildInputs = [ core ];
  };

  async = janePackage {
    pname = "async";
    hash = "0pk7z3h2gi21nfchvmjz2wx516bynf9vgwf84zf5qhvlvqqsmyrx";
    meta.description = "Monadic concurrency library";
    propagatedBuildInputs = [
      async_extra
      textutils
    ];
  };

  async_find = janePackage {
    pname = "async_find";
    hash = "0qsz9f15s5rlk6za10s810v6nlkdxg2g9p1827lcpa7nhjcpi673";
    meta.description = "Directory traversal with Async";
    propagatedBuildInputs = [ async ];
  };

  re2 = janePackage {
    pname = "re2";
    version = "0.12.1";
    hash = "sha256-NPQKKUSwckZx4GN4wX2sc0Mn7bes6p79oZrN6xouc6o=";
    meta.description = "OCaml bindings for RE2, Google's regular expression library";
    propagatedBuildInputs = [ core_kernel ];
    prePatch = ''
      substituteInPlace src/re2_c/dune --replace 'CXX=g++' 'CXX=c++'
      substituteInPlace src/dune --replace '(cxx_flags (:standard \ -pedantic) (-I re2_c/libre2))' '(cxx_flags (:standard \ -pedantic) (-I re2_c/libre2) (-x c++))'
    '';
  };

  shell = janePackage {
    pname = "shell";
    hash = "158857rdr6qgglc5iksg0l54jgf51b5lmsw7nlazpxwdwc9fcn5n";
    meta.description = "Yet another implementation of fork&exec and related functionality";
    buildInputs = [ jst-config ];
    propagatedBuildInputs = [
      re2
      textutils
    ];
  };

  async_shell = janePackage {
    pname = "async_shell";
    hash = "0cxln9hkc3cy522la9yi9p23qjwl69kqmadsq4lnjh5bxdad06sv";
    meta.description = "Shell helpers for Async";
    propagatedBuildInputs = [
      async
      shell
    ];
  };

  core_bench = janePackage {
    pname = "core_bench";
    hash = "00hyzbbj19dkcw0vhfnc8w0ca3zkjriwwvl00ssa0a2g9mygijdm";
    meta.description = "Benchmarking library";
    propagatedBuildInputs = [ textutils ];
  };

  core_extended = janePackage {
    pname = "core_extended";
    hash = "1gwx66235irpf5krb1r25a3c7w52qhmass8hp7rdv89il9jn49w4";
    meta.description = "Extra components that are not as closely vetted or as stable as Core";
    propagatedBuildInputs = [ core ];
  };

  sexp_pretty = janePackage {
    pname = "sexp_pretty";
    hash = "06hdsaszc5cd7fphiblbn4r1sh36xgjwf2igzr2rvlzqs7jiv2v4";
    meta.description = "S-expression pretty-printer";
    propagatedBuildInputs = [
      ppx_base
      re
      sexplib
    ];
  };

  expect_test_helpers_kernel = janePackage {
    pname = "expect_test_helpers_kernel";
    hash = "18ya187y2i2hfxr771sd9vy5jdsa30vhs56yjdhwk06v01b2fzbq";
    meta.description = "Helpers for writing expectation tests";
    buildInputs = [ ppx_jane ];
    propagatedBuildInputs = [
      core_kernel
      sexp_pretty
    ];
  };

  expect_test_helpers = janePackage {
    pname = "expect_test_helpers";
    hash = "0ixqck2lnsmz107yw0q2sr8va80skjpldx7lz4ymjiq2vsghk0rb";
    meta.description = "Async helpers for writing expectation tests";
    propagatedBuildInputs = [
      async
      expect_test_helpers_kernel
    ];
  };

  patience_diff = janePackage {
    pname = "patience_diff";
    hash = "055kd3piadjnplip8c8q99ssh79d4irmhg2wng7aida5pbqp2p9f";
    meta.description = "Diff library using Bram Cohen's patience diff algorithm";
    propagatedBuildInputs = [ core_kernel ];
  };

  ecaml = janePackage {
    pname = "ecaml";
    hash = "0n9xi6agc3lgyj2nsi10cbif0xwn57xyaranad9r285rmbxrgjh7";
    meta.description = "Library for writing Emacs plugin in OCaml";
    propagatedBuildInputs = [
      async
      expect_test_helpers_kernel
    ];
  };

}
