{ janePackage, ocamlbuild, angstrom, cryptokit, ctypes,
  magic-mime, ocaml-migrate-parsetree, octavius, ounit, ppx_deriving, re,
  num, openssl
, ppxlib
}:

rec {

  ocaml-compiler-libs = janePackage {
    pname = "ocaml-compiler-libs";
    hash = "03jds7bszh8wwpfwxb3dg0gyr1j1872wxwx1xqhry5ir0i84bg0s";
    meta.description = "OCaml compiler libraries repackaged";
  };

  sexplib0 = janePackage {
    pname = "sexplib0";
    meta.description = "Library containing the definition of S-expressions and some base converters";
    hash = "07v3ggyss7xhfv14bjk1n87sr42iqwj4cgjiv2lcdfkqk49i2bmi";
  };

  parsexp = janePackage {
    pname = "parsexp";
    hash = "1nyq23s5igd8cf3n4qxprjvhbmb6ighb3fy5mw7hxl0mdgsw5fvz";
    propagatedBuildInputs = [ sexplib0 ];
    meta.description = "S-expression parsing library";
  };

  sexplib = janePackage {
    pname = "sexplib";
    meta.description = "Library for serializing OCaml values to and from S-expressions";
    hash = "1qfl0m04rpcjvc4yw1hzh6r16jpwmap0sa9ax6zjji67dz4szpyb";
    propagatedBuildInputs = [ num parsexp ];
  };

  base = janePackage {
    version = "0.11.1";
    pname = "base";
    hash = "0j6xb4265jr41vw4fjzak6yr8s30qrnzapnc6rl1dxy8bjai0nir";
    propagatedBuildInputs = [ sexplib0 ];
    meta.description = "Full standard library replacement for OCaml";
  };

  stdio = janePackage {
    pname = "stdio";
    hash = "1facajqhvq34g2wrg368y0ajxd6lrj5b3lyzyj0jhdmraxajjcwn";
    propagatedBuildInputs = [ base ];
    meta.description = "Standard IO library for OCaml";
  };

  configurator = janePackage {
    pname = "configurator";
    hash = "0h686630cscav7pil8c3w0gbh6rj4b41dvbnwmicmlkc746q5bfk";
    propagatedBuildInputs = [ stdio ];
    meta.description = "Helper library for gathering system configuration";
  };

  ppx_compare = janePackage {
    pname = "ppx_compare";
    version = "0.11.1";
    hash = "06bq4m1bsm4jlx4g7wh5m99qky7xm4c2g52kaz6pv25hdn5agi2m";
    buildInputs = [ ppxlib ];
    propagatedBuildInputs = [ base ppx_deriving ];
    meta.description = "Generation of comparison functions from types";
  };

  ppx_sexp_conv = janePackage {
    pname = "ppx_sexp_conv";
    version = "0.11.2";
    hash = "0pqwnqy1xp309wvdcaax4lg02yk64lq2w03mbgfvf6ps5ry4gis9";
    propagatedBuildInputs = [ sexplib0 ppxlib ppx_deriving ];
    meta.description = "Generation of S-expression conversion functions from type definitions";
  };

  variantslib = janePackage {
    pname = "variantslib";
    hash = "0hbsk34ghc28h8pzbma923ma2bgnz8lzrgcqqx9bzg161jl4s4r3";
    buildInputs = [ ppxlib ];
    propagatedBuildInputs = [ base ];
    meta.description = "OCaml variants as first class values";
  };

  ppx_variants_conv = janePackage {
    pname = "ppx_variants_conv";
    version = "0.11.1";
    hash = "1yc0gsds5m2nv39zga8nnrca2n75rkqy5dz4xj1635ybz20hhbjd";
    buildInputs = [ ppxlib ];
    propagatedBuildInputs = [ ppx_deriving variantslib ];
    meta.description = "Generation of accessor and iteration functions for OCaml variant types";
  };

  fieldslib = janePackage {
    pname = "fieldslib";
    hash = "1yvjvfax56lmn2lxbykcmhgmxypws1vp9lhnyb8bhbavsv8yc6da";
    propagatedBuildInputs = [ ppxlib ];
    meta.description = "OCaml record fields as first class values";
  };

  ppx_fields_conv = janePackage {
    pname = "ppx_fields_conv";
    hash = "1bb9cmn4js7p3qh8skzyik1pcz6sj1k4xkhf12fg1bjmb5fd0jx1";
    propagatedBuildInputs = [ fieldslib ];
    meta.description = "Generation of accessor and iteration functions for OCaml records";
  };

  ppx_custom_printf = janePackage {
    pname = "ppx_custom_printf";
    hash = "1dvjzvaxhx53jqwrrlxdckwl1azrhs9kvwb48mhgd0jnz65ny726";
    propagatedBuildInputs = [ ppx_sexp_conv ];
    meta.description = "Printf-style format-strings for user-defined string conversion";
  };

  bin_prot = janePackage {
    pname = "bin_prot";
    hash = "1mgbyzsr8h0y4s4j9dv7hsdrxyzhhjww5khwg2spi2my7ia95m0l";
    propagatedBuildInputs = [ ppx_compare ppx_custom_printf ppx_fields_conv ppx_variants_conv ];
    meta.description = "Binary protocol generator";
  };

  jane-street-headers = janePackage {
    pname = "jane-street-headers";
    hash = "0kij4c7qxrja787f3sm3z6mzr322486h2djrlyhnl66vp8hrv8si";
    meta.description = "Jane Street header files";
  };

  ppx_here = janePackage {
    pname = "ppx_here";
    hash = "04njv8s4n54x9rg0012ymd6y6lrnqprnh0f0f6s0jcp79q7mv43i";
    buildInputs = [ ppxlib ];
    meta.description = "Expands [%here] into its location";
  };

  ppx_assert = janePackage {
    pname = "ppx_assert";
    hash = "0qbdrl0rj0midnb6sdyaz00s0d4nb8zrrdf565lcdsi1rbnyrzan";
    buildInputs = [ ppx_here ];
    propagatedBuildInputs = [ ppx_compare ppx_sexp_conv ];
    meta.description = "Assert-like extension nodes that raise useful errors on failure";
  };

  ppx_hash = janePackage {
    version = "0.11.1";
    pname = "ppx_hash";
    hash = "1p0ic6aijxlrdggpmycj12q3cy9xksbq2vq727215maz4snvlf5p";
    propagatedBuildInputs = [ ppx_compare ppx_sexp_conv ];
    meta.description = "A ppx rewriter that generates hash functions from type expressions and definitions";
  };

  ppx_inline_test = janePackage {
    pname = "ppx_inline_test";
    hash = "11n94fz1asjf5vqdgriv0pvsa5lbfpqcyk525c7816w23vskcvq6";
    buildInputs = [ ppxlib ];
    propagatedBuildInputs = [ base ];
    meta.description = "Syntax extension for writing in-line tests in OCaml code";
  };

  ppx_sexp_message = janePackage {
    pname = "ppx_sexp_message";
    hash = "0d94pf0mrmyp905ncgj4w6cc6zpm4nlib6nclslhgs89pxpzg6a0";
    buildInputs = [ ppx_here ];
    propagatedBuildInputs = [ ppx_sexp_conv ];
    meta.description = "A ppx rewriter for easy construction of s-expressions";
  };

  typerep = janePackage {
    pname = "typerep";
    hash = "00j4by75fl9niqvlpiyw6ymlmlmgfzysm8w25cj5wsfsh4yrgr74";
    propagatedBuildInputs = [ base ];
    meta.description = "Runtime types for OCaml";
  };

  ppx_typerep_conv = janePackage {
    version = "0.11.1";
    pname = "ppx_typerep_conv";
    hash = "0a13dpfrrg0rsm8qni1bh7pqcda30l70z8r6yzi5a64bmwk7g5ah";
    buildInputs = [ ppxlib ];
    propagatedBuildInputs = [ ppx_deriving typerep ];
    meta.description = "Generation of runtime types from type declarations";
  };

  ppx_js_style = janePackage {
    pname = "ppx_js_style";
    hash = "1cwqyrkykc8wi60grbid1w072fcvf7k0hd387jz7mxfw44qyb85g";
    propagatedBuildInputs = [ ppxlib octavius ];
    meta.description = "Code style checker for Jane Street Packages";
  };

  ppx_enumerate = janePackage {
    version = "0.11.1";
    pname = "ppx_enumerate";
    hash = "0spx9k1v7vjjb6sigbfs69yndgq76v114jhxvzjmffw7q989cyhr";
    buildInputs = [ ppxlib ];
    propagatedBuildInputs = [ ppx_deriving ];
    meta.description = "Generate a list containing all values of a finite type";
  };

  ppx_base = janePackage {
    pname = "ppx_base";
    hash = "079caqjbxk1d33hy69017n3dwslqy52alvzjddwpdjb04vjadlk6";
    propagatedBuildInputs = [ ppx_compare ppx_enumerate ppx_hash ppx_js_style ];
    meta.description = "Base set of ppx rewriters";
  };

  ppx_bench = janePackage {
    pname = "ppx_bench";
    hash = "0z98r6y4lpj6dy265m771ylx126hq3v1zjsk74yqvpwwd63gx3jz";
    buildInputs = [ ppxlib ppx_inline_test ];
    meta.description = "Syntax extension for writing in-line benchmarks in OCaml code";
  };

  ppx_bin_prot = janePackage {
    version = "0.11.1";
    pname = "ppx_bin_prot";
    hash = "1h60i75bzvhna1axyn662gyrzhh441l79vl142d235i5x31dmnkz";
    buildInputs = [ ppxlib ppx_here ];
    propagatedBuildInputs = [ bin_prot ];
    meta.description = "Generation of bin_prot readers and writers from types";
  };

  ppx_expect = janePackage {
    pname = "ppx_expect";
    hash = "1g0r67vfw9jr75pybiw4ysfiswlzyfpbj0gl91rx62gqdhjh1pga";
    buildInputs = [ ppx_assert ppx_custom_printf ppx_fields_conv ppx_here ppx_variants_conv re ];
    propagatedBuildInputs = [ fieldslib ppx_compare ppx_inline_test ppx_sexp_conv ];
    meta.description = "Cram like framework for OCaml";
  };

  ppx_fail = janePackage {
    pname = "ppx_fail";
    hash = "0d0xadcl7mhp81kspcd2b0nh75h34w5a6s6j9qskjjbjif87wiix";
    buildInputs = [ ppxlib ppx_here ];
    meta.description = "Add location to calls to failwiths";
  };

  ppx_let = janePackage {
    pname = "ppx_let";
    hash = "1ckzwljlb78cdf6xxd24nddnmsihvjrnq75r1b255aj3xgkzsygx";
    buildInputs = [ ppxlib ];
    meta.description = "Monadic let-bindings";
  };

  ppx_optcomp = janePackage {
    pname = "ppx_optcomp";
    hash = "1rahkjq6vpffs7wdz1crgbxkdnlfkj1i3j12c2andy4fhj49glcm";
    buildInputs = [ ppxlib ];
    propagatedBuildInputs = [ ppx_deriving ];
    meta.description = "Optional compilation for OCaml";
  };

  ppx_optional = janePackage {
    pname = "ppx_optional";
    hash = "0aw3hvrsdjpw4ik7rf15ghak31vhdr1lgpphr18mj76rnlrhirmx";
    propagatedBuildInputs = [ ppxlib ];
    meta.description = "Pattern matching on flat options";
  };

  ppx_pipebang = janePackage {
    pname = "ppx_pipebang";
    hash = "0smgq587amlr3hivbbg153p83dj37w30cssp9cffc0v8kg84lfhr";
    buildInputs = [ ppxlib ];
    meta.description = "A ppx rewriter that inlines reverse application operators |> and |!";
  };

  ppx_sexp_value = janePackage {
    pname = "ppx_sexp_value";
    hash = "107zwb580nrmc0l03dl3y3hf12s3c1vv8b8mz6sa4k5afp3s9nkl";
    buildInputs = [ ppx_here ];
    propagatedBuildInputs = [ ppx_sexp_conv ];
    meta.description = "A ppx rewriter that simplifies building s-expressions from OCaml values";
  };

  ppx_jane = janePackage {
    pname = "ppx_jane";
    hash = "0l1p6llaa60mrc5p9400cqv9yy6h76x5wfq3z1cx5xawy0yz4vlb";
    buildInputs = [ ppxlib ];
    propagatedBuildInputs = [ ppx_assert ppx_base ppx_bench ppx_bin_prot ppx_expect ppx_fail ppx_here ppx_let ppx_optcomp ppx_optional ppx_pipebang ppx_sexp_message ppx_sexp_value ppx_typerep_conv ];
    meta.description = "Standard Jane Street ppx rewriters";
  };

  splittable_random = janePackage {
    pname = "splittable_random";
    hash = "1yrvpm6g62f8k6ihccxhfxpvmxbqxhi7p790a8jkdmyfdd1l6z73";
    propagatedBuildInputs = [ ppx_jane ];
    meta.description = "PRNG that can be split into independent streams";
  };

  core_kernel = janePackage {
    version = "0.11.1";
    pname = "core_kernel";
    hash = "1dg7ygy7i64c5gaakb1cp1b26p9ks81vbxmb8fd7jff2q60j2z2g";
    propagatedBuildInputs = [ configurator jane-street-headers sexplib splittable_random ];
    meta.description = "Jane Street's standard library overlay (kernel)";
  };

  spawn = janePackage {
    version = "0.12.0";
    pname = "spawn";
    hash = "0amgj7g9sjlbjivn1mg7yjdmxd21hgp4a0ak2zrm95dmm4gi846i";
    meta.description = "Spawning sub-processes";
  };

  core = janePackage {
    version = "0.11.2";
    pname = "core";
    hash = "0vpsvd75lxb09il2rnzyib9mlr51v1hzqdc9fdxgx353pb5agh8a";
    propagatedBuildInputs = [ core_kernel spawn ];
    meta.description = "Jane Street's standard library overlay";
  };

  textutils_kernel = janePackage {
    pname = "textutils_kernel";
    hash = "0s1ps7h54vgl76pll3y5qa1bw8f4h8wxc8mg8jq6bz8vxvl0dfv4";
    propagatedBuildInputs = [ core_kernel ];
    meta.description = "The subset of textutils using only core_kernel and working in javascript";
  };

  textutils = janePackage {
    pname = "textutils";
    hash = "1jmhpaihnndf4pr8xsk7ws70n4mvv34ry0ggqqpfs3wb2vkcdg6j";
    propagatedBuildInputs = [ core textutils_kernel ];
    meta.description = "Text output utilities";
  };

  re2 = janePackage {
    pname = "re2";
    hash = "0bl65d0nmvr7k1mkkcc4aai86l5qzgn1xxwmszshpwhaz87cqghd";
    propagatedBuildInputs = [ core_kernel ];
    prePatch = ''
      substituteInPlace src/re2_c/jbuild --replace 'CXX=g++' 'CXX=c++'
      substituteInPlace src/jbuild --replace '(cxx_flags ((:standard \ -pedantic) (-I re2_c/libre2)))' '(cxx_flags ((:standard \ -pedantic) (-I re2_c/libre2) (-x c++)))'
    '';
    meta.description = "OCaml bindings for RE2";
  };

  core_extended = janePackage {
    pname = "core_extended";
    hash = "1fvnr6zkpbl48dl7nn3j1dpsrr6bi00iqh282wg5lgdhcsjbc0dy";
    propagatedBuildInputs = [ core re re2 textutils ];
    postPatch = ''
      patchShebangs src/discover.sh
    '';
    meta.description = "Jane Street Capital's standard library overlay";
  };

  async_kernel = janePackage {
    version = "0.11.1";
    pname = "async_kernel";
    hash = "1ssv0gqbdns6by1wdjrrs35cj1c1n1qcfkxs8hj04b7x89wzvf1q";
    propagatedBuildInputs = [ core_kernel ];
    meta.description = "Jane Street Capital's asynchronous execution library (core)";
  };

  protocol_version_header = janePackage {
    pname = "protocol_version_header";
    hash = "159qmkb0dsfmr1lv2ly50aqszpm24bvrm3sw07n2zhkxgy6q613z";
    propagatedBuildInputs = [ core_kernel ocaml-migrate-parsetree ];
    meta.description = "Protocol aware version negotiation";
  };

  async_rpc_kernel = janePackage {
    pname = "async_rpc_kernel";
    hash = "0wl7kp30qxkalk91q5pja9agsvvmdjvb2q7s3m79dlvwwi11l33y";
    propagatedBuildInputs = [ core_kernel async_kernel protocol_version_header ];
    meta.description = "Platform-independent core of Async RPC library";
  };

  async_unix = janePackage {
    pname = "async_unix";
    hash = "1y5za5fdh0x82zdjigxci9zm9jnpfd2lfgpjcq4rih3s28f16sf7";
    propagatedBuildInputs = [ core async_kernel ];
    meta.description = "Jane Street Capital's asynchronous execution library (unix)";
  };

  async_extra = janePackage {
    version = "0.11.1";
    pname = "async_extra";
    hash = "0dmplvqf41820rm5i0l9bx1xmmdlq8zsszi36y2rkjna8991f7s2";
    propagatedBuildInputs = [ async_rpc_kernel async_unix ];
    meta.description = "Jane Street's asynchronous execution library (extra)";
  };

  async = janePackage {
    pname = "async";
    hash = "1i05hzk4mhzj1mw98b2bdbxhnq03jvhkkkw4d948i6265jzrrbv5";
    propagatedBuildInputs = [ async_extra ];
    meta.description = "Jane Street Capital's asynchronous execution library";
  };

  async_find = janePackage {
    pname = "async_find";
    hash = "0s0qafx74ri1vr2vv3iy1j7s3p6gp7vyg0mw5g17iafk0w6lv2iq";
    propagatedBuildInputs = [ async ];
    meta.description = "Directory traversal with Async";
  };

  async_interactive = janePackage {
    pname = "async_interactive";
    hash = "01rlfcylpiak6a2n6q3chp73cvkhvb65n906dj0flmxmagn7dxd1";
    propagatedBuildInputs = [ async ];
    meta.description = "Utilities for building simple command-line based user interfaces";
  };

  async_parallel = janePackage {
    pname = "async_parallel";
    hash = "0hak8ba3rfzqhz5hz2annqmsv5bkqzdihhafp0f58ryrlskafwag";
    propagatedBuildInputs = [ async ];
    meta.description = "Distributed computing library";
  };

  async_shell = janePackage {
    pname = "async_shell";
    hash = "1jb01ygfnhabsy72xlcg11vp7rr37sg555sm0k3yxl4r5az3y2ay";
    propagatedBuildInputs = [ core_extended async ];
    meta.description = "Shell helpers for Async";
  };

  async_ssl = janePackage {
    pname = "async_ssl";
    hash = "1p83fzfla4rb820irdrz3f2hp8kq5zrhw47rqmfv6qydlca1bq64";
    propagatedBuildInputs = [ async ctypes openssl ];
    meta.description = "Async wrappers for SSL";
  };

  sexp_pretty = janePackage {
    pname = "sexp_pretty";
    hash = "0xskahjggbwvvb82fn0jp1didxbgpmgks76xhwp9s3vqkhgz6918";
    propagatedBuildInputs = [ ppx_base re sexplib ];
    meta.description = "S-expression pretty-printer";
  };

  expect_test_helpers_kernel = janePackage {
    pname = "expect_test_helpers_kernel";
    hash = "0m113vq4m1xm3wmwa08r6qjc7p5f0y3ss8s4i2z591ycgs2fxzlj";
    propagatedBuildInputs = [ core_kernel sexp_pretty ];
    meta.description = "Helpers for writing expectation tests";
  };

  expect_test_helpers = janePackage {
    pname = "expect_test_helpers";
    hash = "13n6h7mimwkbsjdix96ghfrmxjd036m4h4zgl8qag00aacqclvpi";
    propagatedBuildInputs = [ async expect_test_helpers_kernel ];
    meta.description = "Async helpers for writing expectation tests";
  };

  cinaps = janePackage {
    pname = "cinaps";
    hash = "0f8cx4xkkk4wqpcbvva8kxdndbgawljp17dwppc6zpjpkjl8s84j";
    propagatedBuildInputs = [ re ];
    meta.description = "Trivial Metaprogramming tool using the OCaml toplevel";
  };

  command_rpc = janePackage {
    pname = "command_rpc";
    hash = "111v4km0ds8ixmpmwg9ck36ap97400mqzhijf57kj6wfwgzcmr2g";
    propagatedBuildInputs = [ async ];
    meta.description = "Utilities for Versioned RPC communication with a child process over stdin and stdout";
  };

  # Deprecated libraries

  ppx_ast = janePackage {
    pname = "ppx_ast";
    hash = "125bzswcwr3nb26ss8ydh8z4218c8fi3s2kvgqp1j1fhc5wwzqgj";
    propagatedBuildInputs = [ ppxlib ];
    meta.description = "Deprecated (see ppxlib)";
  };

  ppx_core = janePackage {
    pname = "ppx_core";
    hash = "11hgm9mxig4cm3c827f6dns9mjv3pf8g6skf10x0gw9xnp1dmzmx";
    propagatedBuildInputs = [ ppxlib ];
    meta.description = "Deprecated (see ppxlib)";
  };

  ppx_driver = janePackage {
    pname = "ppx_driver";
    hash = "00kfx6js2kxk57k4v7hiqvwk7h35whgjihnxf75m82rnaf4yzvfi";
    propagatedBuildInputs = [ ppxlib ];
    meta.description = "Deprecated (see ppxlib)";
  };

  ppx_metaquot = janePackage {
    pname = "ppx_metaquot";
    hash = "1vz8bi56jsz8w0894vgbfsfvmdyh5k1dgv45l8vhkks0s7d3ldji";
    propagatedBuildInputs = [ ppxlib ];
    meta.description = "Deprecated (see ppxlib)";
  };

  ppx_traverse = janePackage {
    pname = "ppx_traverse";
    hash = "1p2n5da4mxh9fk4gvxlibc706bs5xwkbppxd1x0ip1vln5pabbq5";
    propagatedBuildInputs = [ ppxlib ];
    meta.description = "Deprecated (see ppxlib)";
  };

  ppx_traverse_builtins = janePackage {
    pname = "ppx_traverse_builtins";
    hash = "0qlf7i8h8k3a9h8nhb0ki3y1knr6wgbm24f1qaqni53fpvzv0pfb";
    propagatedBuildInputs = [ ppxlib ];
    meta.description = "Deprecated (see ppxlib)";
  };

  ppx_type_conv = janePackage {
    pname = "ppx_type_conv";
    hash = "04dbrglqqhkas25cpjz8xhjcbpk141c35qggzw66bn69izczfmaf";
    propagatedBuildInputs = [ ppxlib ];
    meta.description = "Deprecated (see ppxlib)";
  };

  # Miscellaneous Jane Street packages

  core_bench = janePackage {
    pname = "core_bench";
    hash = "10i28ssfdqxxhq0rvnlp581lr1cq2apkhmm8j83fksjkmbxcrasc";
    propagatedBuildInputs = [ core_extended ];
    meta.description = "Micro-benchmarking library for OCaml";
  };

  csvfields = janePackage {
    pname = "csvfields";
    hash = "10zw4fjlniivfdzzz79lnbvcjnhk5y16m1p8mn4xbs23n6mbix0f";
    propagatedBuildInputs = [ core expect_test_helpers ];
    meta.description = "Runtime support for ppx_xml_conv and ppx_csv_conv";
  };

  ecaml = janePackage {
    pname = "ecaml";
    hash = "1is5156q59s427x3q5nh9wsi8h1x77670bmyilqxasy39yway7g8";
    propagatedBuildInputs = [ async expect_test_helpers_kernel ];
    meta.description = "Writing Emacs plugin in OCaml";
  };

  email_message = janePackage {
    pname = "email_message";
    hash = "131jd72k4s8cdbgg6gyg7w5v8mphdlvdx4fgvh8d9a1m7kkvbxfg";
    propagatedBuildInputs = [ async angstrom core_extended cryptokit magic-mime ounit ];
    meta.description = "E-mail message parser";
  };

  incremental_kernel = janePackage {
    version = "0.11.1";
    pname = "incremental_kernel";
    hash = "1qp9dqncx2h0np0rndqaic4dna8f1dlkqnbjfcdhcim5dp2vg4x6";
    propagatedBuildInputs = [ core_kernel ];
    meta.description = "Library for incremental computations depending only on core_kernel";
  };

  incremental = janePackage {
    pname = "incremental";
    hash = "1xchd3v4kj56wixjrsnj7m7l0374cgkzybihs2b62mn65xf6n7ki";
    propagatedBuildInputs = [ core incremental_kernel ];
    meta.description = "Library for incremental computations";
  };

  incr_map = janePackage {
    pname = "incr_map";
    hash = "01vx9aldxpigz5ah9h337xcw73a7r8449v8l2xbralljhs0zglx9";
    propagatedBuildInputs = [ incremental_kernel ];
    meta.description = "Helpers for incremental operations on map like data structures";
  };

  parsexp_io = janePackage {
    pname = "parsexp_io";
    hash = "0rhdl40jiirvv6fhgjk50n8wzs3jly5d8dyyyfgpjgl39mwkjjnb";
    propagatedBuildInputs = [ parsexp ppx_js_style ];
    meta.description = "S-expression parsing library (IO functions)";
  };

  patience_diff = janePackage {
    pname = "patience_diff";
    hash = "0q7a64fgg97qcd6d8c45gyz63x5vq004axxqvvfg92b8f3x2plx4";
    propagatedBuildInputs = [ core_kernel ];
    meta.description = "Tool and library implementing patience diff";
  };

  posixat = janePackage {
    pname = "posixat";
    hash = "04rs4sl0r4rg9m6l9kkqkmc4n87sv4a4w9ibq4zsjk9j4n6r2df8";
    propagatedBuildInputs = [ ppx_optcomp ppx_sexp_conv sexplib ];
    meta.description = "Binding to the posix *at functions";
  };

  rpc_parallel = janePackage {
    pname = "rpc_parallel";
    hash = "13dx59x73i8mkwv2qkh8gx6kk8arlvghj57k1jdscdmzmyqc9gvn";
    propagatedBuildInputs = [ async ];
    meta.description = "Type-safe library for building parallel applications";
  };

  shexp = janePackage {
    version = "0.11.1";
    pname = "shexp";
    hash = "06yssp7bsmabaxvw9bqxyrsji1gkvl7if5adba3v6h4kilqy7rqg";
    propagatedBuildInputs = [ posixat spawn ];
    meta.description = "Process library and s-expression based shell";
  };

  topological_sort = janePackage {
    pname = "topological_sort";
    hash = "1qnz5b1rs45lsl1ycxd1lglpmh8444gy5khhdp5fvxy987zkzklz";
    propagatedBuildInputs = [ core_kernel ];
    meta.description = "Topological sort algorithm";
  };
}
