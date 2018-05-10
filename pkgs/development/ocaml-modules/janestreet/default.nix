{ stdenv, lib, janePackage, ocaml, ocamlbuild, angstrom, cryptokit, ctypes,
  magic-mime, ocaml-migrate-parsetree, octavius, ounit, ppx_deriving, re,
  zarith, num, openssl }:

rec {

  # Jane Street packages, up to ppx_core

  sexplib = janePackage {
    name = "sexplib";
    meta.description = "Automated S-expression conversion";
    hash = "1agw649n0rnf6h4y2dr1zs1970nncxgjmf90848vbxv8y9im4yy2";
    propagatedBuildInputs = [ num ];
  };

  base = janePackage {
    name = "base";
    hash = "13brvkkj76syh8ws1k3lnvk88jvc6jxx16nsq5ysh558db91v5x7";
    propagatedBuildInputs = [ sexplib ];
    meta.description = "Full standard library replacement for OCaml";
  };

  ocaml-compiler-libs = janePackage {
    name = "ocaml-compiler-libs";
    hash = "0dg9jgwwir99y28bki17cqf3v30apd7cf0qdi8hfwb5pkgp9zdng";
    meta.description = "OCaml compiler libraries repackaged";
  };

  ppx_ast = janePackage {
    name = "ppx_ast";
    hash = "02jsi9b200071i4x0w358by09xabw9v13q7xrx6cdshqxw0q97kf";
    propagatedBuildInputs = [ ocaml-compiler-libs ocaml-migrate-parsetree ];
    meta.description = "OCaml AST used by Jane Street ppx rewriters";
  };

  ppx_traverse_builtins = janePackage {
    name = "ppx_traverse_builtins";
    hash = "0hhw565cwjlr1cwpgkfj0v2kc0lqxyjcrmi9q3hx3344biql8q17";
    meta.description = "Builtins for Ppx_traverse";
  };

  stdio = janePackage {
    name = "stdio";
    hash = "0ydhy4f89f00n0pfgk8fanj6chzx433qnlcrxnddzg4d3dhb4254";
    propagatedBuildInputs = [ base sexplib ];
    meta.description = "Standard IO library for OCaml";
  };

  ppx_core = janePackage {
    name = "ppx_core";
    hash = "0fm26bgf10gk8xl6j4xvwa5s7nmns8rlx7iblb7haj4dxc0qsjhd";
    propagatedBuildInputs = [ ppx_ast ppx_traverse_builtins stdio ];
    meta.description = "Jane Street's standard library for ppx rewriters";
  };

  # Jane Street packages, up to ppx_base

  ppx_optcomp = janePackage {
    name = "ppx_optcomp";
    hash = "134anhlh32s5yjjbiqsrmjw51i08pyghzccmrwg1bipl64q55m6n";
    propagatedBuildInputs = [ ppx_core ];
    meta.description = "Optional compilation for OCaml";
  };

  ppx_driver = janePackage {
    name = "ppx_driver";
    hash = "0kzijcsq32wf33f4spgja3w5jb9s8wnzmr6lpm8lahw05g80q8nj";
    buildInputs = [ ocamlbuild ];
    propagatedBuildInputs = [ ppx_optcomp ];
    meta.description = "Feature-full driver for OCaml AST transformers";
  };

  ppx_metaquot = janePackage {
    name = "ppx_metaquot";
    hash = "1wb8pl5v57yy1g0g61mvgnxgn2ix2r5skiz33g8hdjvx91pbgmv4";
    propagatedBuildInputs = [ ppx_driver ];
    meta.description = "Metaquotations for ppx_ast";
  };

  ppx_type_conv = janePackage {
    name = "ppx_type_conv";
    hash = "0xvn00fzj8lb41slkl91p9z62byg0rlnygdxf4xvrqglg04wa9cz";
    propagatedBuildInputs = [ ppx_metaquot ppx_deriving ];
    meta.description = "Support Library for type-driven code generators";
  };

  ppx_sexp_conv = janePackage {
    name = "ppx_sexp_conv";
    hash = "0kvbm34wbxrcpvrrbh5wq4kzx4yb67iidzcq5x1d4bygvp8x2lzd";
    propagatedBuildInputs = [ ppx_type_conv sexplib ];
    meta.description = "Generation of S-expression conversion functions from type definitions";
  };

  ppx_compare = janePackage {
    name = "ppx_compare";
    hash = "1fjrb7bz7wrykf4pm7s4s32030jdw65hi7kzd22ibd1afnkz3xw1";
    propagatedBuildInputs = [ ppx_type_conv ];
    meta.description = "Generation of comparison functions from types";
  };

  ppx_enumerate = janePackage {
    name = "ppx_enumerate";
    hash = "1b4q1h19bh2xdxgqwdmn5kv95lyvpyf6mfh2fswagf2ajyfshksx";
    propagatedBuildInputs = [ ppx_type_conv ];
    meta.description = "Generate a list containing all values of a finite type";
  };

  ppx_hash = janePackage {
    name = "ppx_hash";
    hash = "12yln0gpf21ifr205qxk7dn83bsj07zhmak2xsjap7xkq4k8g9gc";
    propagatedBuildInputs = [ ppx_compare ppx_sexp_conv ];
    meta.description = "A ppx rewriter that generates hash functions from type expressions and definitions";
  };

  ppx_js_style = janePackage {
    name = "ppx_js_style";
    hash = "11i2cwavbbplhsl5n4zmgpr8gjc4ixa5016vc72y8h78g71jj18n";
    propagatedBuildInputs = [ ppx_metaquot octavius ];
    meta.description = "Code style checker for Jane Street Packages";
  };

  ppx_base = janePackage {
    name = "ppx_base";
    hash = "1rk7dlnhl30prda9q34ic0xv375i52j47bkr664ry3ghklxx6d8y";
    propagatedBuildInputs = [ ppx_enumerate ppx_hash ppx_js_style ];
    meta.description = "Base set of ppx rewriters";
  };

  # Jane Street packages, up to ppx_bin_prot

  fieldslib = janePackage {
    name = "fieldslib";
    hash = "19l05d7hhc74zg48hj0m7sips8z3vpara1f0lvd8h7n46wpbs608";
    propagatedBuildInputs = [ ppx_driver ];
    meta.description = "OCaml record fields as first class values";
  };

  variantslib = janePackage {
    name = "variantslib";
    hash = "0j1qlz7g8ny1qf3a7d38v2a7sxiis1nwcxkvz0myfsc3dkn716an";
    propagatedBuildInputs = [ ppx_driver ];
    meta.description = "OCaml variants as first class values";
  };

  ppx_traverse = janePackage {
    name = "ppx_traverse";
    hash = "1ps7s4vwvzik9wvmwd0i3a1sjgm0xx32yivc2r8ix9qqwylvjllq";
    propagatedBuildInputs = [ ppx_type_conv ];
    meta.description = "Automatic generation of open recursion classes";
  };

  ppx_custom_printf = janePackage {
    name = "ppx_custom_printf";
    hash = "113dvmiy07lb6mf0f88avf4cfkix4q029xqi2w0h26xngp88s31p";
    propagatedBuildInputs = [ ppx_sexp_conv ppx_traverse ];
    meta.description = "Printf-style format-strings for user-defined string conversion";
  };

  ppx_fields_conv = janePackage {
    name = "ppx_fields_conv";
    hash = "1df095qczkzclmdcs1nrm89wswnxivn9kvn6sw65jpvryfkf5v5k";
    propagatedBuildInputs = [ fieldslib ppx_type_conv ];
    meta.description = "Generation of accessor and iteration functions for OCaml records";
  };

  ppx_variants_conv = janePackage {
    name = "ppx_variants_conv";
    hash = "1l19rkclf65f8snw2v0yibkvk28by241dkp6jb0076dyghbln451";
    propagatedBuildInputs = [ ppx_type_conv variantslib ];
    meta.description = "Generation of accessor and iteration functions for OCaml variant types";
  };

  bin_prot = janePackage {
    name = "bin_prot";
    hash = "1yyjpwr2s5l8sm9j77a4cmr92rdx73iy3fwqyxf7dr8hfrmd938v";
    propagatedBuildInputs = [ ppx_compare ppx_custom_printf ppx_fields_conv ppx_variants_conv ];
    meta.description = "Binary protocol generator";
  };

  ppx_here = janePackage {
    name = "ppx_here";
    hash = "0ysx25ai7mpzxfpbswd9k38hpxhjm12bj0iw5ghvhdjnnn07kwcv";
    propagatedBuildInputs = [ ppx_driver ];
    meta.description = "Expands [%here] into its location";
  };

  ppx_bin_prot = janePackage {
    name = "ppx_bin_prot";
    hash = "06n7gs51847p75baay9ar8n15ynqzhdbnwd8xvp8vxs6krr6wpfd";
    propagatedBuildInputs = [ ppx_here bin_prot ];
    meta.description = "Generation of bin_prot readers and writers from types";
  };

  # Jane Street packages, up to ppx_jane

  ppx_assert = janePackage {
    name = "ppx_assert";
    hash = "09xrcs2sk1a9vjn16bd1cpz3b52kbck7fhc7zrz24lv121wspiaj";
    propagatedBuildInputs = [ ppx_sexp_conv ppx_here ppx_compare ];
    meta.description = "Assert-like extension nodes that raise useful errors on failure";
  };

  ppx_inline_test = janePackage {
    name = "ppx_inline_test";
    hash = "0ar4lpl3zwb7k1f4clqsw1hyzwa104gf118a2i89c4hvj2721jwf";
    propagatedBuildInputs = [ ppx_metaquot ];
    meta.description = "Syntax extension for writing in-line tests in OCaml code";
  };

  typerep = janePackage {
    name = "typerep";
    hash = "11na0kag6aggckx7326zq8hh9pzymkwqfxsd25fswskk5lpnvwqv";
    propagatedBuildInputs = [ base ];
    meta.description = "Runtime types for OCaml";
  };

  ppx_bench = janePackage {
    name = "ppx_bench";
    hash = "17l5shhi613l02yfipyr4hna3lj94kn6zy746rvsgcibyc7nybq6";
    propagatedBuildInputs = [ ppx_inline_test ];
    meta.description = "Syntax extension for writing in-line benchmarks in OCaml code";
  };

  ppx_expect = janePackage {
    name = "ppx_expect";
    hash = "0qq07iqfsbksklwn7rr1wdz79kji0iyq5qkyfwxrxm0ci9fz0h1w";
    propagatedBuildInputs = [ ppx_inline_test ppx_fields_conv ppx_custom_printf ppx_assert ppx_variants_conv re ];
    meta.description = "Cram like framework for OCaml";
  };

  ppx_fail = janePackage {
    name = "ppx_fail";
    hash = "0cwz16xy5s0ijm9y98lh9089ic7wd161njpdncgsxy6lgsjawap2";
    propagatedBuildInputs = [ ppx_here ppx_metaquot ];
    meta.description = "Add location to calls to failwiths";
  };

  ppx_let = janePackage {
    name = "ppx_let";
    hash = "0smdxkjh4nxrf3mwzfvkjbymvwbz04v70k2gwxsaz5f6wvnhyvmm";
    propagatedBuildInputs = [ ppx_driver ];
    meta.description = "Monadic let-bindings";
  };

  ppx_optional = janePackage {
    name = "ppx_optional";
    hash = "1qmc0yzp9jab8yndxs0ca3qx35wyhfwiknqk0gfjmar2ji87zlzn";
    propagatedBuildInputs = [ ppx_metaquot ];
    meta.description = "Pattern matching on flat options";
  };

  ppx_pipebang = janePackage {
    name = "ppx_pipebang";
    hash = "0lzw6qc9f9g7zkbhhp4603b3mj3jvca4phx40f95d49y370325qx";
    propagatedBuildInputs = [ ppx_metaquot ];
    meta.description = "A ppx rewriter that inlines reverse application operators |> and |!";
  };

  ppx_sexp_message = janePackage {
    name = "ppx_sexp_message";
    hash = "1gddia4ry2pmnh4qj5855a044lqs23g5h038bkny73xg7w06jhrk";
    propagatedBuildInputs = [ ppx_sexp_conv ppx_here ];
    meta.description = "A ppx rewriter for easy construction of s-expressions";
  };

  ppx_sexp_value = janePackage {
    name = "ppx_sexp_value";
    hash = "1xd5ln997wka8x4dba58yh525a5f36sklngg2z7iyiss7xi4yg7i";
    propagatedBuildInputs = [ ppx_sexp_conv ppx_here ];
    meta.description = "A ppx rewriter that simplifies building s-expressions from OCaml values";
  };

  ppx_typerep_conv = janePackage {
    name = "ppx_typerep_conv";
    hash = "1bk8zgagf6q5lb7icsrbzs05c8dz1gij0clzk39am40l83zs3ain";
    propagatedBuildInputs = [ ppx_type_conv typerep ];
    meta.description = "Generation of runtime types from type declarations";
  };

  ppx_jane = janePackage {
    name = "ppx_jane";
    hash = "1lhzcfh129dc54bkg16rnldi97682nlzdr8a47ham3hg2kkab8kr";
    propagatedBuildInputs = [ ppx_base ppx_bench ppx_bin_prot ppx_expect ppx_fail ppx_let ppx_optional ppx_pipebang ppx_sexp_message ppx_sexp_value ppx_typerep_conv ];
    meta.description = "Standard Jane Street ppx rewriters";
  };

  # Jane Street packages, up to core

  configurator = janePackage {
    name = "configurator";
    hash = "0lydjj4r21ipmc91hyf91mjjvcibk4r7ipan8bqfzb5l490r95rp";
    propagatedBuildInputs = [ base stdio ];
    meta.description = "Helper library for gathering system configuration";
  };

  jane-street-headers = janePackage {
    name = "jane-street-headers";
    hash = "1sqyqzhgi52vq33i8ha2pmjg026qiqmpaqmibs3pfj4jsscwl842";
    meta.description = "Jane Street header files";
  };

  core_kernel = janePackage {
    name = "core_kernel";
    hash = "00iqd9wcana2blgdih1lq9zqd31agr6az912bhsklyarvvcn9hcb";
    propagatedBuildInputs = [ configurator jane-street-headers ppx_jane ];
    meta.description = "Jane Street's standard library overlay (kernel)";
  };

  spawn = janePackage {
    name = "spawn";
    hash = "1av1pjkiqq3nz0rjmykiylhf0iv6d1ssvqqj6wcc3c0bzvgyih0p";
    meta.description = "Spawning sub-processes";
  };

  core = janePackage {
    name = "core";
    hash = "06cra34rlqpmxh4f3v1vps9fs7hy90jjnipdvcf9z8cn925mdj46";
    propagatedBuildInputs = [ core_kernel spawn ];
    meta.description = "Jane Street's standard library overlay";
  };

  # Jane Street packages, up to core_extended

  re2 = janePackage {
    name = "re2";
    version = "0.10.1";
    hash = "1d39brryfaj5fqp1kzw67n1bvfxv28xi058mk5il14wj40y5ldh1";
    propagatedBuildInputs = [ core_kernel ];
    meta = {
      description = "OCaml bindings for RE2";
      broken = stdenv.isDarwin;
    };
  };

  textutils = janePackage {
    name = "textutils";
    hash = "0mnmrp8kd443qx9gahrwr04a8q4hskcad2i1k9amiypbwy566s37";
    propagatedBuildInputs = [ core textutils_kernel ];
    meta.description = "Text output utilities";
  };

  textutils_kernel = janePackage {
    name = "textutils_kernel";
    hash = "0w7nf7sycffff318fxr42ss1fxa3bsy9kj7y27dl1whrajip9mb7";
    propagatedBuildInputs = [ core_kernel ocaml-migrate-parsetree ];
    meta.description = "The subset of textutils using only core_kernel and working in javascript";
  };

  core_extended = janePackage {
    name = "core_extended";
    hash = "0g9adnr68l4ggayilmvz9nnf2slvnp0jzknjrxk10cab72l97rv4";
    propagatedBuildInputs = [ core re2 textutils ];
    postPatch = ''
      patchShebangs src/discover.sh
    '';
    meta = {
      description = "Jane Street Capital's standard library overlay";
    };
  };

  # Jane Street async packages

  async_kernel = janePackage {
    name = "async_kernel";
    hash = "09dzfyfmjf9894yimf1fpnc2l1v342f51a2wjr3d23pw6xnbcrl0";
    propagatedBuildInputs = [ core_kernel ];
    meta.description = "Jane Street Capital's asynchronous execution library (core)";
  };

  async_rpc_kernel = janePackage {
    name = "async_rpc_kernel";
    hash = "1ardfr4vwbzc41qa2ccmzp15m9w3nbdl9cy4crvm87fi0ngkhixy";
    propagatedBuildInputs = [ core_kernel async_kernel protocol_version_header ];
    meta.description = "Platform-independent core of Async RPC library";
  };

  async_unix = janePackage {
    name = "async_unix";
    hash = "151pn0543fwvi5gkdkbd05v8y9gjbxi1n69r4jxzc0bh842xx4xz";
    propagatedBuildInputs = [ core async_kernel ];
    meta.description = "Jane Street Capital's asynchronous execution library (unix)";
  };

  async_extra = janePackage {
    name = "async_extra";
    hash = "0vf3nfj8h7vnigs8l8m1bsg6w3szgaylaps6mbl4dsaihxdc732n";
    propagatedBuildInputs = [ async_rpc_kernel async_unix ];
    meta.description = "Jane Street's asynchronous execution library (extra)";
  };

  async = janePackage {
    name = "async";
    hash = "05ldvyw75648qrjx7q794m9llmlnqklh97lc09fv8biw515dby3d";
    propagatedBuildInputs = [ async_extra ];
    meta.description = "Jane Street Capital's asynchronous execution library";
  };

  async_find = janePackage {
    name = "async_find";
    hash = "05cpnz1m09h276cq6v3bh7da4iai14gmlh4cnh64v41f8hssw63s";
    propagatedBuildInputs = [ async ];
    meta.description = "Directory traversal with Async";
  };

  async_interactive = janePackage {
    name = "async_interactive";
    hash = "1h2419l6nlqph3ipp5zdwyq55d3s602i4bv4jhsridmzy6cxxdxs";
    propagatedBuildInputs = [ async ];
    meta.description = "Utilities for building simple command-line based user interfaces";
  };

  async_parallel = janePackage {
    name = "async_parallel";
    hash = "0r8q73v26w3grj9n9wyrf65cq9w6pfzrmg9iswsy4jjb5r02bpr5";
    propagatedBuildInputs = [ async ];
    meta.description = "Distributed computing library";
  };

  async_shell = janePackage {
    name = "async_shell";
    hash = "1snkr944l3a627k23yh8f0lr900dpg2aym2l59fpp75s29pyk5md";
    propagatedBuildInputs = [ core_extended async ];
    meta = {
      description = "Shell helpers for Async";
    };
  };

  async_ssl = janePackage {
    name = "async_ssl";
    hash = "1cb9wpmgifa5vj9gadbav6bq6vxcm3g0jc6wxnkj3hgvnj35j2vy";
    propagatedBuildInputs = [ async ctypes openssl ];
    meta.description = "Async wrappers for SSL";
  };

  # Jane Street packages, up to expect_test_helpers

  sexp_pretty = janePackage {
    name = "sexp_pretty";
    hash = "106r91ahzdr8yvphs1s3ck8r89c4qhpcl9q6j5rbxrbihgb71i8d";
    propagatedBuildInputs = [ ppx_base re ];
    meta.description = "S-expression pretty-printer";
  };

  expect_test_helpers_kernel = janePackage {
    name = "expect_test_helpers_kernel";
    hash = "027pwfkdnz8rzgg9dqa4x2ir0zn8lav7gh64cih35r455xbfnvpr";
    propagatedBuildInputs = [ core_kernel sexp_pretty ];
    meta.description = "Helpers for writing expectation tests";
  };

  expect_test_helpers = janePackage {
    name = "expect_test_helpers";
    hash = "0rzsgj8h73gx18sz1a1d3pbrjkb0vd6shl1h71n4xl05njcfb73r";
    propagatedBuildInputs = [ async expect_test_helpers_kernel ];
    meta.description = "Async helpers for writing expectation tests";
  };

  # Miscellaneous Jane Street packages

  bignum = janePackage {
    name = "bignum";
    hash = "0vs52aqq7pwazgv35zdd66c5v5ha1wrgrcmzc17c2qbswy8wcc37";
    propagatedBuildInputs = [ core_kernel zarith num ];
    meta.description = "Core-flavoured wrapper around zarith's arbitrary-precision rationals";
  };

  cinaps = janePackage {
    name = "cinaps";
    hash = "1mwllcakvsirxpbwcqlglwqkiz8cks7vbjf1jvngs9703mx1xdcy";
    propagatedBuildInputs = [ re ];
    meta.description = "Trivial Metaprogramming tool using the OCaml toplevel";
  };

  command_rpc = janePackage {
    name = "command_rpc";
    hash = "0lq1vcz8qyyqabrz9isw2pw50663lwmq4w3187jp99ygar9lk5n2";
    propagatedBuildInputs = [ async ];
    meta.description = "Utilities for Versioned RPC communication with a child process over stdin and stdout";
  };

  core_bench = janePackage {
    name = "core_bench";
    hash = "1py68z848gj5wdmknqmzdb6zg65k5zchv6i6vzygi5nszn3zzwgc";
    propagatedBuildInputs = [ core_extended ];
    meta = {
      description = "Micro-benchmarking library for OCaml";
    };
  };

  core_profiler = janePackage {
    name = "core_profiler";
    hash = "1vqkb8fzhs0k94k78whjnsznj85qa18kp0bq73mdkffz9562hdyr";
    propagatedBuildInputs = [ core_extended ];
    meta = {
      description = "Profiling library";
    };
  };

  csvfields = janePackage {
    name = "csvfields";
    hash = "1qvcm2xkpw5ca5za2dfvz154h6kzm565wvynh7fffvrj2q719flm";
    propagatedBuildInputs = [ core expect_test_helpers ];
    meta.description = "Runtime support for ppx_xml_conv and ppx_csv_conv";
  };

  ecaml = janePackage {
    name = "ecaml";
    hash = "1h8m8nznsyc8md8f5rx3845lpl37ijqpxkpd52w92xy5hlc9bk1k";
    propagatedBuildInputs = [ async expect_test_helpers_kernel ];
    meta.description = "Writing Emacs plugin in OCaml";
  };

  email_message = janePackage {
    name = "email_message";
    hash = "0p56lak1ynqmimapsz529ankgdyd5yk90c0193q8fzv7fvvrzkzd";
    propagatedBuildInputs = [ async angstrom core_extended cryptokit magic-mime ounit ];
    meta = {
      description = "E-mail message parser";
    };
  };

  incremental_kernel = janePackage {
    name = "incremental_kernel";
    hash = "15xw3l07fdqk5sla37fdvfnwykvq6fyrj9b2lwhc29rq0444m1yz";
    propagatedBuildInputs = [ core_kernel ];
    meta.description = "Library for incremental computations depending only on core_kernel";
  };

  incremental = janePackage {
    name = "incremental";
    hash = "14hh7kxj70bpgylnx1fj3s5c40d12sgcb11cnh1xh7nwm190a9c2";
    propagatedBuildInputs = [ core incremental_kernel ];
    meta.description = "Library for incremental computations";
  };

  incr_map = janePackage {
    name = "incr_map";
    hash = "0s6c7f8a80s7bnjxcs7mdgm45i24d1j0vw4i2j884z1ssjrk33hw";
    propagatedBuildInputs = [ incremental_kernel ];
    meta.description = "Helpers for incremental operations on map like data structures";
  };

  ocaml_plugin = janePackage {
    name = "ocaml_plugin";
    hash = "0b63ciajc9hcjs3pl0chlj475y60i3l5mjzaiqmyz1pryfqpri7r";
    buildInputs = [ ocamlbuild ];
    propagatedBuildInputs = [ async ];
    meta.description = "Automatically build and dynlink ocaml source files";
  };

  parsexp = janePackage {
    name = "parsexp";
    hash = "1k1z6kyp7c53l0wspz6qpvbb46bbr6aimnr06y6y1prxrpazm62w";
    propagatedBuildInputs = [ ppx_compare ppx_fields_conv ppx_js_style ppx_sexp_value ];
    meta.description = "S-expression parsing library";
  };

  parsexp_io = janePackage {
    name = "parsexp_io";
    hash = "0l9jrfm1zz0y6bfxla2s0fwjlvs9361ky83z3xwdlc48fgzks3a5";
    propagatedBuildInputs = [ parsexp ];
    meta.description = "S-expression parsing library (IO functions)";
  };

  patience_diff = janePackage {
    name = "patience_diff";
    hash = "11ws6hsalmq7zc7wp37mj7zs3qaqkq4zlnwr06ybryv6vz62xj1l";
    propagatedBuildInputs = [ core_kernel ];
    meta.description = "Tool and library implementing patience diff";
  };

  posixat = janePackage {
    name = "posixat";
    hash = "0dmjzbpbmzl94h4c1gk6k75wglnvk1kqcm4zs4nb9hy2ja8ldl9x";
    propagatedBuildInputs = [ ppx_sexp_conv ];
    meta.description = "Binding to the posix *at functions";
  };

  protocol_version_header = janePackage {
    name = "protocol_version_header";
    hash = "1vl1kfn8n1zdm3vh7228c58vprac4v7mpqks60k8rnzjj4w2mj1n";
    propagatedBuildInputs = [ core_kernel ocaml-migrate-parsetree ];
    meta.description = "Protocol aware version negotiation";
  };

  rpc_parallel = janePackage {
    name = "rpc_parallel";
    hash = "01nyjqgdj351ykdaqqpaljwzac48x824lzfpma64lbp6plqmjlbf";
    propagatedBuildInputs = [ async ];
    meta.description = "Type-safe library for building parallel applications";
  };

  shexp = janePackage {
    name = "shexp";
    hash = "1ck5gcsdp93194bw6d1i116zplyaqrz1r36h6mvrw5x7i2549n9p";
    propagatedBuildInputs = [ posixat spawn ];
    meta.description = "Process library and s-expression based shell";
  };

  topological_sort = janePackage {
    name = "topological_sort";
    hash = "08w1dx30frj2bxxk8djl23cd43sassjkrmissyhagn9fmq2l904m";
    propagatedBuildInputs = [ core_kernel ];
    meta.description = "Topological sort algorithm";
  };
}
