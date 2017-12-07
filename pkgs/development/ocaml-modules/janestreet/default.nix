{ stdenv, lib, janePackage, ocamlbuild, cryptokit, ctypes, magic-mime,
  ocaml-migrate-parsetree, octavius, ounit, ppx_deriving, re, zarith,
  openssl }:

rec {

  # Jane Street packages, up to ppx_core

  sexplib = janePackage {
    name = "sexplib";
    version = "0.9.1";
    hash = "087md38l73lp24j2lmwi053jjav00k11r06s6whmff1xlhj70wdj";
    meta.description = "Automated S-expression conversion";
  };

  base = janePackage {
    name = "base";
    version = "0.9.1";
    hash = "09gj30zyv23gv3gkf2pb3d3ywmkgd74dq8sfaps5xarr3grvndhm";
    propagatedBuildInputs = [ sexplib ];
    meta.description = "Full standard library replacement for OCaml";
  };

  ocaml-compiler-libs = janePackage {
    name = "ocaml-compiler-libs";
    hash = "1jz3nfrb6295sj4xj1j0zld8mhfj0xy2k4vlp9yf9sh3748n090l";
    meta.description = "OCaml compiler libraries repackaged";
  };

  ppx_ast = janePackage {
    name = "ppx_ast";
    hash = "0p9v4q3cjz8wwdrh6bjidani2npzvhdy8isnqwigqkl6n326dba9";
    propagatedBuildInputs = [ ocaml-compiler-libs ocaml-migrate-parsetree ];
    meta.description = "OCaml AST used by Jane Street ppx rewriters";
  };

  ppx_traverse_builtins = janePackage {
    name = "ppx_traverse_builtins";
    hash = "10ajvz02ka6qimlfrq7py4ljhk8awqkga6240kn8j046b4xfyxzi";
    meta.description = "Builtins for Ppx_traverse";
  };

  stdio = janePackage {
    name = "stdio";
    hash = "1c08jg930j7yxn0sjvlm3fs2fvwaf15sn9513yf1rb7y1lxrgwc4";
    propagatedBuildInputs = [ base ];
    meta.description = "Standard IO library for OCaml";
  };

  ppx_core = janePackage {
    name = "ppx_core";
    hash = "15400zxxkqdimmjpdjcs36gcbxbrhylmaczlzwd6x65v1h9aydz3";
    propagatedBuildInputs = [ ppx_ast ppx_traverse_builtins stdio ];
    meta.description = "Jane Street's standard library for ppx rewriters";
  };

  # Jane Street packages, up to ppx_base

  ppx_optcomp = janePackage {
    name = "ppx_optcomp";
    hash = "1wfj6fnh92s81yncq7yyhmax7j6zpjj1sg1f3qa1f9c5kf4kkzrd";
    propagatedBuildInputs = [ ppx_core ];
    meta.description = "Optional compilation for OCaml";
  };

  ppx_driver = janePackage {
    name = "ppx_driver";
    hash = "1w3khwnvy18nkh673zrbhcs6051hs7z5z5dib7npkvpxndw22hwj";
    buildInputs = [ ocamlbuild ];
    propagatedBuildInputs = [ ppx_optcomp ];
    meta.description = "Feature-full driver for OCaml AST transformers";
  };

  ppx_metaquot = janePackage {
    name = "ppx_metaquot";
    hash = "15qfd3s4x2pz006nx5316laxd3gqqi472x432qg4rfx4yh3vn31k";
    propagatedBuildInputs = [ ppx_driver ];
    meta.description = "Metaquotations for ppx_ast";
  };

  ppx_type_conv = janePackage {
    name = "ppx_type_conv";
    hash = "0a0gxjvjiql9vg37k0akn8xr5724nv3xb7v37xpidv7ld927ks7p";
    propagatedBuildInputs = [ ppx_metaquot ppx_deriving ];
    meta.description = "Support Library for type-driven code generators";
  };

  ppx_sexp_conv = janePackage {
    name = "ppx_sexp_conv";
    hash = "03cg2sym0wvpd5l7q4w9bclp589z5byygwsmnnq9h1ih56cmd55l";
    propagatedBuildInputs = [ ppx_type_conv sexplib ];
    meta.description = "Generation of S-expression conversion functions from type definitions";
  };

  ppx_compare = janePackage {
    name = "ppx_compare";
    hash = "0wrszpvn1nms5sb5rb29p7z1wmqyd15gfzdj4ax8f843p5ywx3w9";
    propagatedBuildInputs = [ ppx_type_conv ];
    meta.description = "Generation of comparison functions from types";
  };

  ppx_enumerate = janePackage {
    name = "ppx_enumerate";
    hash = "1dfy86j2z12p5n9yrwaakx1ngphs5246vxy279kz6i6j34cwxm46";
    propagatedBuildInputs = [ ppx_type_conv ];
    meta.description = "Generate a list containing all values of a finite type";
  };

  ppx_hash = janePackage {
    name = "ppx_hash";
    hash = "1w1riy2sqd9i611sc5f5z2rqqgjl2gvvkzi5xibpv309nacnl01d";
    propagatedBuildInputs = [ ppx_compare ppx_sexp_conv ];
    meta.description = "A ppx rewriter that generates hash functions from type expressions and definitions";
  };

  ppx_js_style = janePackage {
    name = "ppx_js_style";
    hash = "09k02b1l2r7svf9l3ls69h8xydsyiang2ziigxnny2i7gy7b0w59";
    propagatedBuildInputs = [ ppx_metaquot octavius ];
    meta.description = "Code style checker for Jane Street Packages";
  };

  ppx_base = janePackage {
    name = "ppx_base";
    hash = "0qikfzbkd2wyxfrvizz6rgi6vg4ykvxkivacj4gr178dbgfl5if3";
    propagatedBuildInputs = [ ppx_enumerate ppx_hash ppx_js_style ];
    meta.description = "Base set of ppx rewriters";
  };

  # Jane Street packages, up to ppx_bin_prot

  fieldslib = janePackage {
    name = "fieldslib";
    hash = "1wxh59888l1bfz9ipnbcas58gwg744icaixzdbsg4v8f7wymc501";
    propagatedBuildInputs = [ ppx_driver ];
    meta.description = "OCaml record fields as first class values";
  };

  variantslib = janePackage {
    name = "variantslib";
    hash = "0kj53n62193j58q9vip8lfhhyf6w9d25wyvxzc163hx5m68yw0fz";
    propagatedBuildInputs = [ ppx_driver ];
    meta.description = "OCaml variants as first class values";
  };

  ppx_traverse = janePackage {
    name = "ppx_traverse";
    hash = "1sdqgwyq0w71i03vhc5jq4jk6rsbgwhvain48fnrllpkb5kj2la2";
    propagatedBuildInputs = [ ppx_type_conv ];
    meta.description = "Automatic generation of open recursion classes";
  };

  ppx_custom_printf = janePackage {
    name = "ppx_custom_printf";
    hash = "0cjy2c2c5g3qxqvwx1yb6p7kbmmpnpb1hll55f7a44x215lg8x19";
    propagatedBuildInputs = [ ppx_sexp_conv ppx_traverse ];
    meta.description = "Printf-style format-strings for user-defined string conversion";
  };

  ppx_fields_conv = janePackage {
    name = "ppx_fields_conv";
    hash = "0qp8zgmk58iskzrkf4g06i471kg6lrh3wqpy9klrb8pp9mg0xr9z";
    propagatedBuildInputs = [ fieldslib ppx_type_conv ];
    meta.description = "Generation of accessor and iteration functions for OCaml records";
  };

  ppx_variants_conv = janePackage {
    name = "ppx_variants_conv";
    hash = "1xayhyglgbdjqvb9123kjbwjcv0a3n3302nb0j7g8gmja8w5y834";
    propagatedBuildInputs = [ ppx_type_conv variantslib ];
    meta.description = "Generation of accessor and iteration functions for OCaml variant types";
  };

  bin_prot = janePackage {
    name = "bin_prot";
    hash = "0cy6lhksx4jypkrnj3ha31p97ghslki0bx5rpnzc2v28mfp6pzh1";
    propagatedBuildInputs = [ ppx_compare ppx_custom_printf ppx_fields_conv ppx_variants_conv ];
    meta.description = "Binary protocol generator";
  };

  ppx_here = janePackage {
    name = "ppx_here";
    hash = "0pjscw5ydxgy4fcxakgsazpp09ka057w5n2fp2dpkv2k5gil6rzh";
    propagatedBuildInputs = [ ppx_driver ];
    meta.description = "Expands [%here] into its location";
  };

  ppx_bin_prot = janePackage {
    name = "ppx_bin_prot";
    hash = "0qw9zqrc5yngzrzpk9awnlnd68xrb7wz5lq807c80ibxk0xvnqn3";
    propagatedBuildInputs = [ ppx_here bin_prot ];
    meta.description = "Generation of bin_prot readers and writers from types";
  };

  # Jane Street packages, up to ppx_jane

  ppx_assert = janePackage {
    name = "ppx_assert";
    hash = "1s5c75wkc46nlcwmgic5h7f439s26ssrzrcil501c5kpib2hlv6z";
    propagatedBuildInputs = [ ppx_sexp_conv ppx_here ppx_compare ];
    meta.description = "Assert-like extension nodes that raise useful errors on failure";
  };

  ppx_inline_test = janePackage {
    name = "ppx_inline_test";
    hash = "01xml88ahrzqnc7g1ib184jbqxpdfx4gn2wdvi09dpi4i0jahy33";
    propagatedBuildInputs = [ ppx_metaquot ];
    meta.description = "Syntax extension for writing in-line tests in OCaml code";
  };

  typerep = janePackage {
    name = "typerep";
    hash = "0hlc0xiznli1k6azv2mhm1s4xghhxqqd957np7828bfp7r8n2jy3";
    propagatedBuildInputs = [ base ];
    meta.description = "Runtime types for OCaml";
  };

  ppx_bench = janePackage {
    name = "ppx_bench";
    hash = "1qk4y6c2mpw7bqjppi2nam74vs2sc89wzq162j92wsqxyqsv4p93";
    propagatedBuildInputs = [ ppx_inline_test ];
    meta.description = "Syntax extension for writing in-line benchmarks in OCaml code";
  };

  ppx_expect = janePackage {
    name = "ppx_expect";
    hash = "1bik53k51wcqv088f0h10n3ms9h51yvg6ha3g1s903i2bxr3xs6b";
    propagatedBuildInputs = [ ppx_inline_test ppx_fields_conv ppx_custom_printf ppx_assert ppx_variants_conv re ];
    meta.description = "Cram like framework for OCaml";
  };

  ppx_fail = janePackage {
    name = "ppx_fail";
    hash = "0qz0vlazasjyg7cv3iwpzxlvsah3zmn9dzd029xxqr1bji067s32";
    propagatedBuildInputs = [ ppx_here ppx_metaquot ];
    meta.description = "Add location to calls to failwiths";
  };

  ppx_let = janePackage {
    name = "ppx_let";
    hash = "1b914a5nynwxjvfx42v61yigvjhnd548m4yqjfchf38dmqi1f4nr";
    propagatedBuildInputs = [ ppx_driver ];
    meta.description = "Monadic let-bindings";
  };

  ppx_optional = janePackage {
    name = "ppx_optional";
    hash = "1vknsarxba0zcp5k2jb31wfpvqrv3bpanxbahfl5s2fwspsfdc82";
    propagatedBuildInputs = [ ppx_metaquot ];
    meta.description = "Pattern matching on flat options";
  };

  ppx_pipebang = janePackage {
    name = "ppx_pipebang";
    hash = "1wyfyyjvyi94ds1p90l60wdr85q2v3fq1qdf3gnv9zjfy6sb0g9h";
    propagatedBuildInputs = [ ppx_metaquot ];
    meta.description = "A ppx rewriter that inlines reverse application operators |> and |!";
  };

  ppx_sexp_message = janePackage {
    name = "ppx_sexp_message";
    hash = "0r0skyr1zf2jh48xrxbs45gzywynhlivkq24xwc0qq435fmc2jqv";
    propagatedBuildInputs = [ ppx_sexp_conv ppx_here ];
    meta.declarations = "A ppx rewriter for easy construction of s-expressions";
  };

  ppx_sexp_value = janePackage {
    name = "ppx_sexp_value";
    hash = "0hha5mmx700m8fy9g4znb8278l09chgwlpshny83vsmmzgq2jhah";
    propagatedBuildInputs = [ ppx_sexp_conv ppx_here ];
    meta.declarations = "A ppx rewriter that simplifies building s-expressions from OCaml values";
  };

  ppx_typerep_conv = janePackage {
    name = "ppx_typerep_conv";
    hash = "0bzgfpbqijwxm8x9jq1zb4xi5sbzymk17lw5rylri3hf84p60aq1";
    propagatedBuildInputs = [ ppx_type_conv typerep ];
    meta.description = "Generation of runtime types from type declarations";
  };

  ppx_jane = janePackage {
    name = "ppx_jane";
    hash = "16m5iw0qyp452nqj83kd0g0x3rw40lrz7392hwpd4di1wi6v2qzc";
    propagatedBuildInputs = [ ppx_base ppx_bench ppx_bin_prot ppx_expect ppx_fail ppx_let ppx_optional ppx_pipebang ppx_sexp_message ppx_sexp_value ppx_typerep_conv ];
    meta.description = "Standard Jane Street ppx rewriters";
  };

  # Jane Street packages, up to core

  configurator = janePackage {
    name = "configurator";
    version = "0.9.1";
    hash = "1q0s0ghcrcrxdj6zr9zr27g7sr4qr9l14kizjphwqwwvgbzawdix";
    propagatedBuildInputs = [ ppx_base ];
    meta.description = "Helper library for gathering system configuration";
  };

  jane-street-headers = janePackage {
    name = "jane-street-headers";
    hash = "0cdab6sblsidjbwvyvmspykyhqh44rpsjzi2djbfd5m4vh2h14gy";
    meta.description = "Jane Street header files";
  };

  core_kernel = janePackage {
    name = "core_kernel";
    hash = "05iwvggx9m81x7ijgv9gcv5znf5rmsmb76dg909bm9gkr3hbh7wh";
    propagatedBuildInputs = [ configurator jane-street-headers ppx_jane ];
    meta.description = "Jane Street's standard library overlay (kernel)";
  };

  spawn = janePackage {
    name = "spawn";
    hash = "1w53b8ni06ajj62yaqjy0pkbm952l0m5fzr088yk15078qaxsnb5";
    meta.description = "Spawning sub-processes";
  };

  core = janePackage {
    name = "core";
    hash = "0x05ky8l75k2dnpsa02vmqcr7p7q0vvc6279psq3iybrwcvab9yi";
    propagatedBuildInputs = [ core_kernel spawn ];
    meta.description = "Jane Street's standard library overlay";
  };

  # Jane Street packages, up to core_extended

  re2 = janePackage {
    name = "re2";
    hash = "1qmhl3yd6y0lq401rz72b1bsbpglb0wighpxn3x8y1ixq415p4xi";
    propagatedBuildInputs = [ core_kernel ];
    meta = {
      description = "OCaml bindings for RE2";
      broken = stdenv.isDarwin;
    };
  };

  textutils = janePackage {
    name = "textutils";
    hash = "1y6j2qw7rc8d80343lfv1dygnfrhn2qllz57mx28pl5kan743f6d";
    propagatedBuildInputs = [ core ];
    meta.description = "Text output utilities";
  };

  core_extended = janePackage {
    name = "core_extended";
    hash = "05cnzzj0kigz9c9gsmd6mfar82wmkbqm9qzrydb80sy2fz5b30rk";
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
    hash = "1zwxhzy7f9900rcjls2fql9cpfmwrcah3fazzdz4h2i51f41w62x";
    propagatedBuildInputs = [ core_kernel ];
    meta.description = "Jane Street Capital's asynchronous execution library (core)";
  };

  async_rpc_kernel = janePackage {
    name = "async_rpc_kernel";
    hash = "1xk3s6s3xkj182p10kig2cqy8md6znif3v661h9cd02n8s57c40b";
    propagatedBuildInputs = [ core_kernel async_kernel ];
    meta.description = "Platform-independent core of Async RPC library";
  };

  async_unix = janePackage {
    name = "async_unix";
    hash = "0yd4z28j5vdj2zxqi0fkgh2ic1s9h740is2dk0raga0zr5a1z03d";
    propagatedBuildInputs = [ core async_kernel ];
    meta.description = "Jane Street Capital's asynchronous execution library (unix)";
  };

  async_extra = janePackage {
    name = "async_extra";
    hash = "0rpy5lc5dh5mir7flq1jrppd8imby8wyw191yg4nmklg28xp5sx0";
    propagatedBuildInputs = [ async_rpc_kernel async_unix ];
    meta.description = "Jane Street's asynchronous execution library (extra)";
  };

  async = janePackage {
    name = "async";
    hash = "10ykzym19srgdiikj0s74dndx5nk15hjq1r2hc61iz48f6caxkb1";
    propagatedBuildInputs = [ async_extra ];
    meta.description = "Jane Street Capital's asynchronous execution library";
  };

  async_find = janePackage {
    name = "async_find";
    hash = "11dmhdzgf5kn4m0cm6zr28wpwhi2kr4lak9nmgxbrxsq28bcncxq";
    propagatedBuildInputs = [ async ];
    meta.description = "Directory traversal with Async";
  };

  async_interactive = janePackage {
    name = "async_interactive";
    hash = "1mmqqp6bi2wg7bmgf0sw34jn3iyl5kbm200dax8yqq6rfprcs49j";
    propagatedBuildInputs = [ async ];
    meta.description = "Utilities for building simple command-line based user interfaces";
  };

  async_parallel = janePackage {
    name = "async_parallel";
    hash = "0mdprhr1pv4g65g10gr3gaifrzknsdgarwfdbjlvhzfs86075kyn";
    propagatedBuildInputs = [ async ];
    meta.description = "Distributed computing library";
  };

  async_shell = janePackage {
    name = "async_shell";
    hash = "02clpz3xv3i5avzifwalylb9gfxzpgnr8bnlfsjixxfk2m7kvsj2";
    propagatedBuildInputs = [ core_extended async ];
    meta = {
      description = "Shell helpers for Async";
    };
  };

  async_ssl = janePackage {
    name = "async_ssl";
    hash = "01w3bg38q61lc3hfh8jsr0sy1ylyv0m6g6h9yvsk8ngj6qk70nss";
    propagatedBuildInputs = [ async ctypes openssl ];
    meta.description = "Async wrappers for SSL";
  };

  # Jane Street packages, up to expect_test_helpers

  sexp_pretty = janePackage {
    name = "sexp_pretty";
    hash = "1bx8va468j5b813m0vsh1jzgb6h2qnnjfmjlf2hb82sarv8lllfx";
    propagatedBuildInputs = [ ppx_base re ];
    meta.description = "S-expression pretty-printer";
  };

  expect_test_helpers_kernel = janePackage {
    name = "expect_test_helpers_kernel";
    hash = "1ycqir8sqgq5nialnrfg29nqn0cqg6jjpgv24drdycdhqf5r2zg6";
    propagatedBuildInputs = [ core_kernel sexp_pretty ];
    meta.description = "Helpers for writing expectation tests";
  };

  expect_test_helpers = janePackage {
    name = "expect_test_helpers";
    hash = "0rsh6rwbqfcrqisk8jp7srlnicsadbzrs02ri6zyx0p3lmznw5r2";
    propagatedBuildInputs = [ async expect_test_helpers_kernel ];
    meta.description = "Async helpers for writing expectation tests";
  };

  # Miscellaneous Jane Street packages

  bignum = janePackage {
    name = "bignum";
    hash = "0g80mzsi7vc1kq4mzha8y9nl95h6cd041vix3wjrqgkdvb1qd4f3";
    propagatedBuildInputs = [ core_kernel zarith ];
    meta.description = "Core-flavoured wrapper around zarith's arbitrary-precision rationals";
  };

  cinaps = janePackage {
    name = "cinaps";
    hash = "02fpjiwrygkpx2q4jfldhbqh0mqxmf955wizr8k4vmsq4wsis0p5";
    propagatedBuildInputs = [ re ];
    meta.description = "Trivial Metaprogramming tool using the OCaml toplevel";
  };

  command_rpc = janePackage {
    name = "command_rpc";
    hash = "0w58z9jkz5qzbvf33wrzhfshzdvnrphj6dq8dmi52ykhfvxm7824";
    propagatedBuildInputs = [ async ];
    meta.description = "Utilities for Versioned RPC communication with a child process over stdin and stdout";
  };

  core_bench = janePackage {
    name = "core_bench";
    hash = "1m2q7217nmcsck29i59djkm0h6z3aj0i01niijzr5f6ilbnmyd3h";
    propagatedBuildInputs = [ core_extended ];
    meta = {
      description = "Micro-benchmarking library for OCaml";
    };
  };

  core_profiler = janePackage {
    name = "core_profiler";
    hash = "1ir2v3wdfbf5xzqcma16asc73mkx2q6dzq5y1bx6q1rpa7iznx44";
    propagatedBuildInputs = [ core_extended ];
    meta = {
      description = "Profiling library";
    };
  };

  csvfields = janePackage {
    name = "csvfields";
    hash = "0lbvs1kwl22ryxhw6s089f6683hj2920bn518mvr22rnv7qijy0v";
    propagatedBuildInputs = [ core ];
    meta.description = "Runtime support for ppx_xml_conv and ppx_csv_conv";
  };

  ecaml = janePackage {
    name = "ecaml";
    hash = "1a2534bzbwgpm71aj3sm71sm0lkcjdfjj1mk91p1pg9kxn8c5x4i";
    propagatedBuildInputs = [ async ];
    meta.description = "Writing Emacs plugin in OCaml";
  };

  email_message = janePackage {
    name = "email_message";
    hash = "0cpaf6wn5g883bxdz029bksvrfzih99m7hzbb30fhqglmpmmkniz";
    propagatedBuildInputs = [ async core_extended cryptokit magic-mime ounit ];
    meta = {
      description = "E-mail message parser";
    };
  };

  incremental_kernel = janePackage {
    name = "incremental_kernel";
    hash = "0zq48wbgqcflh84n10iygi8aa3f0zzmgc7r0jwvsyg7i8zccgvf5";
    propagatedBuildInputs = [ core_kernel ];
    meta.description = "Library for incremental computations depending only on core_kernel";
  };

  incremental = janePackage {
    name = "incremental";
    hash = "05sx8ia46v4dlvzcn7xgjcwxvbd0wmvv9r2bpvniapjnwr1nvcfh";
    propagatedBuildInputs = [ core incremental_kernel ];
    meta.description = "Library for incremental computations";
  };

  incr_map = janePackage {
    name = "incr_map";
    hash = "0358qg9irxbbhn18laqww3mn43mdwvlbr0h2mvg3vdbb2c5jp4fv";
    propagatedBuildInputs = [ incremental_kernel ];
    meta.description = "Helpers for incremental operations on map like data structures";
  };

  ocaml_plugin = janePackage {
    name = "ocaml_plugin";
    hash = "0q33swnlx9p1gcn1aj95501kapb7cnbzbsavid69csczwmzcxr14";
    buildInputs = [ ocamlbuild ];
    propagatedBuildInputs = [ async ];
    meta.description = "Automatically build and dynlink ocaml source files";
  };

  parsexp = janePackage {
    name = "parsexp";
    hash = "0brrifvnfqbfk873v6y5b2jixs2d73hpispj9r440kca5cfsv23b";
    propagatedBuildInputs = [ ppx_compare ppx_fields_conv ppx_js_style ppx_sexp_value ];
    meta.description = "S-expression parsing library";
  };

  parsexp_io = janePackage {
    name = "parsexp_io";
    hash = "0gcmh4dg48xgszladq92yhk1hf492zf0smz462xrwknzlfdkz6a5";
    propagatedBuildInputs = [ parsexp ];
    meta.description = "S-expression parsing library (IO functions)";
  };

  patience_diff = janePackage {
    name = "patience_diff";
    hash = "0vpx9xj1ich5qmj3m26vlmix3nsdj7pd1xzhqwbc7ad2kqwy3grg";
    propagatedBuildInputs = [ core_kernel ];
    meta.description = "Tool and library implementing patience diff";
  };

  posixat = janePackage {
    name = "posixat";
    hash = "0ak93dyzi6sc6gb0j07fj85b24d8bv6g2hm7jj5xwb39kjwh51jl";
    propagatedBuildInputs = [ ppx_sexp_conv ];
    meta.description = "Binding to the posix *at functions";
  };

  rpc_parallel = janePackage {
    name = "rpc_parallel";
    hash = "0s72msl2p27bz0knjlpgy5qwp0w4z76cq801ps0sab35f8jjfs38";
    propagatedBuildInputs = [ async ];
    meta.description = "Type-safe library for building parallel applications";
  };

  shexp = janePackage {
    name = "shexp";
    hash = "1fkz4l9z4i0fz2kccd5blm2j9x2x4z6y1cn29wjmc3spqfxbq37y";
    propagatedBuildInputs = [ posixat spawn ];
    meta.description = "Process library and s-expression based shell";
  };

  topological_sort = janePackage {
    name = "topological_sort";
    hash = "1d64fyq0clsgham9p1f5rk01z8pxalglp92xmqw2iznyw0vxhvsy";
    propagatedBuildInputs = [ core_kernel ];
    meta.description = "Topological sort algorithm";
  };

  typerep_extended = janePackage {
    name = "typerep_extended";
    hash = "15gq8mrvlipd616rffr3f0wqw5d0ijnnizix610g2d5viirh0j9p";
    propagatedBuildInputs = [ core_kernel ];
    meta.description = "Runtime types for OCaml (Extended)";
  };

}
