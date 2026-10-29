{
  self,
  fetchpatch,
  lib,
  openssl,
  zstd,
}:

with self;

{

  accessor = janePackage {
    pname = "accessor";
    version = "0.14.1";
    minimalOCamlVersion = "4.09";
    hash = "0wm2081kzd5zsqs516cn3f975bnnmnyynv8fa818gmfa65i6mxm8";
    meta.description = "Library that makes it nicer to work with nested functional data structures";
    propagatedBuildInputs = [ higher_kinded ];
  };

  accessor_async = janePackage {
    pname = "accessor_async";
    version = "0.14.1";
    minimalOCamlVersion = "4.09";
    hash = "1193hzvlzm7vcl9p67fs8al2pvkw9n2wz009m2l3lp35mrx8aq1w";
    meta.description = "Accessors for Async types, for use with the Accessor library";
    propagatedBuildInputs = [
      accessor_core
      async_kernel
    ];
  };

  accessor_base = janePackage {
    pname = "accessor_base";
    version = "0.14.1";
    minimalOCamlVersion = "4.09";
    hash = "1xjbvvijkyw4dlys47x4896y3kqm2zn0yg60cqrp57i2dwxg0nsj";
    meta.description = "Accessors for Base types, for use with the Accessor library";
    propagatedBuildInputs = [ ppx_accessor ];
  };

  accessor_core = janePackage {
    minimalOCamlVersion = "4.09";
    pname = "accessor_core";
    version = "0.14.1";
    hash = "1cdkv34m6czhacivpbb2sasj83fgcid6gnqk30ig9i84z8nh2gw2";
    meta.description = "Accessors for Core types, for use with the Accessor library";
    meta.broken = true; # Not compatible with ppxlib ≥ 0.23
    propagatedBuildInputs = [
      accessor_base
      core_kernel
    ];
  };

  async = janePackage {
    pname = "async";
    hash = "086v93div4h9l02n7wzv3xx3i6xvddazydm9qlfa72ad55x3vzy0";
    meta.description = "Monadic concurrency library";
    propagatedBuildInputs = [
      async_rpc_kernel
      async_unix
      textutils
    ];
    doCheck = false; # we don't have netkit_sockets
  };

  async_extra = janePackage {
    pname = "async_extra";
    hash = "16cnz9h4jkc3b0837s5z0iv92q7n5nw77g8qshq8pwq639y8ail4";
    meta.description = "Monadic concurrency library";
    propagatedBuildInputs = [ async_kernel ];
  };

  async_find = janePackage {
    pname = "async_find";
    hash = "0vlcpdr15bgrwrmixvs6ij88kvk8vzzrijz3zm0svxih0naf8ylx";
    meta.description = "Directory traversal with Async";
    propagatedBuildInputs = [ async ];
  };

  async_inotify = janePackage {
    pname = "async_inotify";
    hash = "0i0hf7nsir316ijixdj43qf0p3b6yapvcm2jzp7bhpf4r2kxislv";
    meta.description = "Async wrapper for inotify";
    propagatedBuildInputs = [
      async_find
      inotify
    ];
  };

  async_interactive = janePackage {
    pname = "async_interactive";
    hash = "1cnmv9mipa6k6xd303ngdbxmiab2202f3w3pgq8l1970w8hb78il";
    meta.description = "Utilities for building simple command-line based user interfaces";
    propagatedBuildInputs = [ async ];
  };

  async_js = janePackage {
    pname = "async_js";
    hash = "0rld8792lfwbinn9rhrgacivz49vppgy29smpqnvpga89wchjv0v";
    meta.description = "Small library that provide Async support for JavaScript platforms";
    buildInputs = [ js_of_ocaml-ppx ];
    propagatedBuildInputs = [
      async_rpc_kernel
      js_of_ocaml
      uri-sexp
    ];
  };

  async_kernel = janePackage {
    pname = "async_kernel";
    hash = "17giakwl0xhyxvxrkn12dwjdghc53q8px81z7cc3k6f102bsbdy6";
    meta.description = "Monadic concurrency library";
    propagatedBuildInputs = [ core_kernel ];
  };

  async_rpc_kernel = janePackage {
    pname = "async_rpc_kernel";
    hash = "1bwq3gkq057dd1fhrqz9kqq8a956nn87zaxvr0qcpiczzjv3zmvm";
    meta.description = "Platform-independent core of Async RPC library";
    propagatedBuildInputs = [
      async_kernel
      protocol_version_header
    ];
  };

  async_sendfile = janePackage {
    pname = "async_sendfile";
    hash = "1w3gwwpgfzqjhblxnxh64g64q6kgjzzxx90inswfhycc88pnvdna";
    meta.description = "Thin wrapper around [Linux_ext.sendfile] to send full files";
    propagatedBuildInputs = [ async_unix ];
  };

  async_shell = janePackage {
    pname = "async_shell";
    hash = "1r00z620nqv2jxz2xrp2gsyc30h8dd2w9qsnys2fkqbgpxlbgdc7";
    meta.description = "Shell helpers for Async";
    propagatedBuildInputs = [
      async
      shell
    ];
  };

  async_smtp = janePackage {
    pname = "async_smtp";
    hash = "1xf3illn7vikdxldpnc29n4z8sv9f0wsdgdvl4iv93qlvjk8gzck";
    meta.description = "SMTP client and server";
    propagatedBuildInputs = [
      async_extra
      async_inotify
      async_sendfile
      async_shell
      async_ssl
      email_message
      resource_cache
      re2_stable
      sexp_macro
    ];
  };

  async_ssl = janePackage {
    pname = "async_ssl";
    hash = "0ykys3ckpsx5crfgj26v2q3gy6wf684aq0bfb4q8p92ivwznvlzy";
    meta.description = "Async wrappers for SSL";
    meta.broken = true;
    buildInputs = [ dune-configurator ];
    propagatedBuildInputs = [
      async
      ctypes
      ctypes-foreign
      openssl
    ];
    # in ctypes.foreign 0.18.0 threaded and unthreaded have been merged
    postPatch = ''
      substituteInPlace bindings/dune \
        --replace "ctypes.foreign.threaded" "ctypes.foreign"
    '';
  };

  async_unix = janePackage {
    pname = "async_unix";
    hash = "1wgnr0vdsknqrfnf6irmwnvyngndsnvvl1sfnj3v6fhwk4nswnrs";
    meta.description = "Monadic concurrency library";
    propagatedBuildInputs = [
      async_kernel
      core
    ];
  };

  base = janePackage {
    pname = "base";
    version = "0.14.1";
    hash = "1hizjxmiqlj2zzkwplzjamw9rbnl0kh44sxgjpzdij99qnfkzylf";
    minimalOCamlVersion = "4.07";
    meta.description = "Full standard library replacement for OCaml";
    buildInputs = [ dune-configurator ];
    propagatedBuildInputs = [ sexplib0 ];
    checkInputs = [ alcotest ];
  };

  base_bigstring = janePackage {
    pname = "base_bigstring";
    hash = "1ald2m7qywhxbygv58dzpgaj54p38zn0aiqd1z7i95kf3bsnsjqa";
    minimalOCamlVersion = "4.07";
    meta.description = "String type based on [Bigarray], for use in I/O and C-bindings";
    propagatedBuildInputs = [ ppx_jane ];
  };

  base_quickcheck = janePackage {
    pname = "base_quickcheck";
    version = "0.14.1";
    hash = "0apq3d9xb0zdaqsl4cjk5skyig57ff1plndb2mh0nn3czvfhifxs";
    minimalOCamlVersion = "4.04.2";
    meta.description = "Randomized testing framework, designed for compatibility with Base";
    propagatedBuildInputs = [
      ppx_base
      ppx_fields_conv
      ppx_let
      ppx_sexp_value
      splittable_random
    ];
  };

  bignum = janePackage {
    pname = "bignum";
    hash = "009ygr64q810p9iq4mykzz4ci00i5mzgpmq35jiyaiqm27bjam21";
    propagatedBuildInputs = [
      core_kernel
      zarith
      zarith_stubs_js
    ];
    meta.description = "Core-flavoured wrapper around zarith's arbitrary-precision rationals";
  };

  bin_prot = janePackage {
    pname = "bin_prot";
    hash = "1qyqbfp4zdc2jb87370cdgancisqffhf9x60zgh2m31kqik8annr";
    minimalOCamlVersion = "4.04.2";
    meta.description = "Binary protocol generator";
    propagatedBuildInputs = [
      ppx_compare
      ppx_custom_printf
      ppx_fields_conv
      ppx_optcomp
      ppx_variants_conv
    ];
  };

  bonsai = janePackage {
    pname = "bonsai";
    hash = "0k4grabwqc9sy4shzp77bgfvyajvvc0l8qq89ia7cvlwvly7gv6a";
    meta.description = "Library for building dynamic webapps, using Js_of_ocaml";
    buildInputs = [ ppx_pattern_bind ];
    propagatedBuildInputs = [ incr_dom ];
  };

  cinaps = janePackage {
    pname = "cinaps";
    hash = "0ms1j2kh7i5slyw9v4w9kdz52dkwl5gqcnvn89prgimhk2vmichj";
    minimalOCamlVersion = "4.07";
    meta.description = "Trivial metaprogramming tool";
    propagatedBuildInputs = [ re ];
    checkInputs = [ ppx_jane ];
  };

  core = janePackage {
    pname = "core";
    version = "0.14.1";
    hash = "1isrcl07nkmdm6akqsqs9z8s6zvva2lvg47kaagy7gsbyszrqb82";
    meta.description = "System-independent part of Core";
    buildInputs = [ jst-config ];
    propagatedBuildInputs = [
      core_kernel
      spawn
      timezone
    ];
    doCheck = false; # we don't have quickcheck_deprecated
  };

  core_bench = janePackage {
    pname = "core_bench";
    hash = "04h6hzxk347pqyrrbgqrw9576sq4yf70fgq9xam3kajrqwdh3dhx";
    meta.description = "Benchmarking library";
    propagatedBuildInputs = [ textutils ];
  };

  core_extended = janePackage {
    pname = "core_extended";
    hash = "1pbm6xbc3h0fhrymyr1yb9b1jk7n88gfi3pylqz2cs8haxr2pb3a";
    meta.description = "Extra components that are not as closely vetted or as stable as Core";
    propagatedBuildInputs = [ core ];
  };

  core_kernel = janePackage {
    pname = "core_kernel";
    version = "0.14.1";
    hash = "0pikg4ln6177gbs0jfix7xj50zlcm7058h64lxnd7wspnj7mq8sd";
    meta.description = "System-independent part of Core";
    buildInputs = [ jst-config ];
    propagatedBuildInputs = [
      base_bigstring
      sexplib
    ];
    doCheck = false; # we don't have quickcheck_deprecated
  };

  core_unix = janePackage {
    pname = "core_unix";
    hash = "0irfmpx6iksxk2r8mdizjn75h71qh4p2f1s9x2ggckzqj9y904ck";
    meta.description = "Unix-specific portions of Core";
    propagatedBuildInputs = [ core ];
  };

  csvfields = janePackage {
    pname = "csvfields";
    hash = "09jmz6y6nwd96dcx6g8ydicxssi72v1ks276phbc9n19wwg9hkaz";
    propagatedBuildInputs = [
      core
      num
    ];
    meta.description = "Runtime support for ppx_xml_conv and ppx_csv_conv";
  };

  delimited_parsing = janePackage {
    pname = "delimited_parsing";
    hash = "1dnr5wqacryx1kj38i9iifc3457pchr887xphzz2nhlbizq3d7qa";
    propagatedBuildInputs = [
      async
      core_extended
    ];
    meta.description = "Parsing of character (e.g., comma) separated and fixed-width values";
  };

  ecaml = janePackage {
    pname = "ecaml";
    hash = "052qglpwzrx3c4gy3zr6dmsmfbi5gj4fs2jhx9yrsqb9hj8g36mj";
    meta.description = "Library for writing Emacs plugin in OCaml";
    propagatedBuildInputs = [
      async
      expect_test_helpers_core
    ];
  };

  email_message = janePackage {
    pname = "email_message";
    hash = "0k8hjkq91ikl7wjxs04k523jbkhl6q4abj6v0lzlbjiybmrpp69n";
    meta.description = "E-mail message parser";
    propagatedBuildInputs = [
      angstrom
      async
      base64
      cryptokit
      magic-mime
      re2
    ];
  };

  expect_test_helpers_async = janePackage {
    pname = "expect_test_helpers_async";
    hash = "175sjkx3b10d8vacp369rv53nxbiaxw1xhwy832g7ffk1by8l2m1";
    meta.description = "Async helpers for writing expectation tests";
    propagatedBuildInputs = [
      async
      expect_test_helpers_core
    ];
  };

  expect_test_helpers_core = janePackage {
    pname = "expect_test_helpers_core";
    hash = "1drl15akp4jz4wf26dr2y2nblvnhz14xsnb3ai8dg45y711svs2i";
    meta.description = "Helpers for writing expectation tests";
    propagatedBuildInputs = [
      core_kernel
      sexp_pretty
    ];
  };

  fieldslib = janePackage {
    pname = "fieldslib";
    hash = "0nxx35lrb4f6zfs5l80a7cg7azf19c6g31vn9qjjpaxf6lgkck2n";
    minimalOCamlVersion = "4.04.2";
    meta.description = "Syntax extension to define first class values representing record fields, to get and set record fields, iterate and fold over all fields of a record and create new record values";
    propagatedBuildInputs = [ base ];
  };

  higher_kinded = janePackage {
    pname = "higher_kinded";
    version = "0.14.1";
    minimalOCamlVersion = "4.09";
    hash = "05jvxgqsx3j2v8rqpd91ah76dgc1q2dz38kjklmx0vms4r4gvlsx";
    meta.description = "Library with an encoding of higher kinded types in OCaml";
    propagatedBuildInputs = [
      base
      ppx_jane
    ];
  };

  incr_dom = janePackage {
    pname = "incr_dom";
    hash = "0mi98cwi4npdh5vvcz0pb4sbb9j9dydl52s51rswwc3kn8mipxfx";
    meta.description = "Library for building dynamic webapps, using Js_of_ocaml";
    buildInputs = [ js_of_ocaml-ppx ];
    propagatedBuildInputs = [
      async_js
      incr_map
      incr_select
      virtual_dom
    ];
    patches = [ ./incr_dom_jsoo_4_0.patch ];
  };

  incr_map = janePackage {
    pname = "incr_map";
    hash = "0s0s7qfydvvvnqby4v5by5jdnd5kxqsdr65mhm11w4fn125skryz";
    meta.description = "Helpers for incremental operations on map like data structures";
    buildInputs = [ ppx_pattern_bind ];
    propagatedBuildInputs = [ incremental ];
  };

  incr_select = janePackage {
    pname = "incr_select";
    hash = "18ril6z57mw89gzc9zhz6p1phwm1xr6phppicvqpqmi0skvvnrg6";
    meta.description = "Handling of large set of incremental outputs from a single input";
    propagatedBuildInputs = [ incremental ];
  };

  incremental = janePackage {
    pname = "incremental";
    hash = "0nyaiy7r2spvn2ij9z5rghd5gbjk1y3ai4jn0i8q81arp7cf6zc7";
    meta.description = "Library for incremental computations";
    propagatedBuildInputs = [ core_kernel ];
  };

  jane-street-headers = janePackage {
    pname = "jane-street-headers";
    hash = "12n40mlgjnc09fxc0hp0npsxdlxja2w828683zpb32nrzqkg6z4c";
    minimalOCamlVersion = "4.04.2";
    meta.description = "Jane Street C header files";
  };

  jst-config = janePackage {
    pname = "jst-config";
    hash = "0hzw0crgj0kjxsvr10wng7gqy948v98hnijh30lgq3v62jdsjra8";
    meta.description = "Compile-time configuration for Jane Street libraries";
    buildInputs = [
      dune-configurator
      ppx_assert
      stdio
    ];
  };

  ocaml-compiler-libs = janePackage {
    pname = "ocaml-compiler-libs";
    version = "0.12.4";
    minimalOCamlVersion = "4.04.1";
    hash = "sha256-W+KUguz55yYAriHRMcQy8gRPzh2TZSJnexG1JI8TLgI=";
    meta.description = "OCaml compiler libraries repackaged";
  };

  parsexp = janePackage {
    pname = "parsexp";
    version = "0.14.1";
    hash = "1nr0ncb8l2mkk8pqzknr7fsqw5kpz8y102kyv5bc0x7c36v0d4zy";
    minimalOCamlVersion = "4.04.2";
    meta.description = "S-expression parsing library";
    propagatedBuildInputs = [
      base
      sexplib0
    ];
  };

  patience_diff = janePackage {
    pname = "patience_diff";
    hash = "1np88s226ndhbwynpdqygrycahp8m1mx28f1xk54kvds8znnq2i0";
    meta.description = "Diff library using Bram Cohen's patience diff algorithm";
    propagatedBuildInputs = [ core_kernel ];
  };

  posixat = janePackage {
    pname = "posixat";
    hash = "0aana1lzq4514kna7hr301b5iv6gcg6zhgrx8s8vaad1q38yfp6c";
    minimalOCamlVersion = "4.07";
    propagatedBuildInputs = [
      ppx_optcomp
      ppx_sexp_conv
    ];
    meta.description = "Binding to the posix *at functions";
  };

  ppx_accessor = janePackage {
    pname = "ppx_accessor";
    version = "0.14.3";
    minimalOCamlVersion = "4.09";
    hash = "sha256:1c8blzh2f34vbm1z3mnvh670c6vda70chw805n2hmkd9j46l0cll";
    meta.description = "[@@deriving] plugin to generate accessors for use with the Accessor libraries";
    propagatedBuildInputs = [ accessor ];
  };

  ppx_assert = janePackage {
    pname = "ppx_assert";
    hash = "03mzgm4smrczp5dg3mpr6zc2v6a54n0r01k4ww820yrr25hcf8ip";
    minimalOCamlVersion = "4.04.2";
    meta.description = "Assert-like extension nodes that raise useful errors on failure";
    propagatedBuildInputs = [
      ppx_cold
      ppx_compare
      ppx_here
      ppx_sexp_conv
    ];
  };

  ppx_base = janePackage {
    pname = "ppx_base";
    hash = "1wv3q0qyghm0c5izq03y97lv3czqk116059mg62wx6valn22a000";
    minimalOCamlVersion = "4.04.2";
    meta = {
      description = "Base set of ppx rewriters";
      mainProgram = "ppx-base";
    };
    propagatedBuildInputs = [
      ppx_cold
      ppx_enumerate
      ppx_hash
      ppx_js_style
    ];
  };

  ppx_bench = janePackage {
    pname = "ppx_bench";
    version = "0.14.1";
    hash = "12r7jgqgpb4i4cry3rgyl2nmxcscs5w7mmk06diz7i49r27p96im";
    minimalOCamlVersion = "4.04.2";
    meta.description = "Syntax extension for writing in-line benchmarks in ocaml code";
    propagatedBuildInputs = [ ppx_inline_test ];
  };

  ppx_bin_prot = janePackage {
    pname = "ppx_bin_prot";
    hash = "1qryjxhyz3kn5jz5wm62j59lhjhd1mp7nbsj0np9qnbpapnnr1zg";
    minimalOCamlVersion = "4.04.2";
    meta.description = "Generation of bin_prot readers and writers from types";
    propagatedBuildInputs = [
      bin_prot
      ppx_here
    ];
    doCheck = false; # circular dependency with ppx_jane
  };

  ppx_cold = janePackage {
    pname = "ppx_cold";
    hash = "0ciqs6f9ab73gq4krj14xzzba4ydcxph214m87i1s0xp25hwxr8v";
    minimalOCamlVersion = "4.04.2";
    meta.description = "Expands [@cold] into [@inline never][@specialise never][@local never]";
    propagatedBuildInputs = [ ppxlib ];
  };

  ppx_compare = janePackage {
    pname = "ppx_compare";
    hash = "11pj76dimx2f7l8m85myzp6yzx9xcg0bqi97s7ayssvkckm57390";
    minimalOCamlVersion = "4.04.2";
    meta.description = "Generation of comparison functions from types";
    propagatedBuildInputs = [
      ppxlib
      base
    ];
    doCheck = false; # test build rule broken
  };

  ppx_custom_printf = janePackage {
    pname = "ppx_custom_printf";
    version = "0.14.1";
    hash = "0c1m65kn27zvwmfwy7kk46ga76yw2a3ik9jygpy1b6nn6pi026w9";
    minimalOCamlVersion = "4.04.2";
    meta.description = "Printf-style format-strings for user-defined string conversion";
    propagatedBuildInputs = [ ppx_sexp_conv ];
  };

  ppx_enumerate = janePackage {
    pname = "ppx_enumerate";
    hash = "1sriid4vh10p80wwvn46v1g16m646qw5r5xzwlymyz5gbvq2zf40";
    minimalOCamlVersion = "4.04.2";
    meta.description = "Generate a list containing all values of a finite type";
    propagatedBuildInputs = [ ppxlib ];
  };

  ppx_expect = janePackage {
    pname = "ppx_expect";
    version = "0.14.1";
    hash = "0vbbnjrzpyk5p0js21lafr6fcp2wqka89p1876rdf472cmg0l7fv";
    minimalOCamlVersion = "4.04.2";
    meta.description = "Cram like framework for OCaml";
    propagatedBuildInputs = [
      ppx_here
      ppx_inline_test
      re
    ];
    doCheck = false; # circular dependency with ppx_jane
  };

  ppx_fields_conv = janePackage {
    pname = "ppx_fields_conv";
    version = "0.14.2";
    hash = "1zwirwqry24b48bg7d4yc845hvcirxyymzbw95aaxdcck84d30n8";
    minimalOCamlVersion = "4.04.2";
    meta.description = "Generation of accessor and iteration functions for ocaml records";
    propagatedBuildInputs = [
      fieldslib
      ppxlib
    ];
  };

  ppx_fixed_literal = janePackage {
    pname = "ppx_fixed_literal";
    hash = "0s7rb4dhz4ibhh42a9sfxjj3zbwfyfmaihr92hpdv5j9xqn3n8mi";
    minimalOCamlVersion = "4.04.2";
    meta.description = "Simpler notation for fixed point literals";
    propagatedBuildInputs = [ ppxlib ];
  };

  ppx_hash = janePackage {
    pname = "ppx_hash";
    hash = "1zf03xdrg4jig7pdcrdpbabyjkdpifb31z2z1bf9wfdawybdhwkq";
    minimalOCamlVersion = "4.04.2";
    meta.description = "PPX rewriter that generates hash functions from type expressions and definitions";
    propagatedBuildInputs = [
      ppx_compare
      ppx_sexp_conv
    ];
  };

  ppx_here = janePackage {
    pname = "ppx_here";
    hash = "09zcyigaalqccs9s0h7n0535clgfmqb9s4p1jbgcqji9zj8w426s";
    minimalOCamlVersion = "4.04.2";
    meta.description = "Expands [%here] into its location";
    propagatedBuildInputs = [ ppxlib ];
    doCheck = false; # test build rules broken
  };

  ppx_inline_test = janePackage {
    pname = "ppx_inline_test";
    version = "0.14.1";
    hash = "1ajdna1m9l1l3nfigyy33zkfa3yarfr6s086jdw2pcfwlq1fhhl4";
    minimalOCamlVersion = "4.04.2";
    meta.description = "Syntax extension for writing in-line tests in ocaml code";
    propagatedBuildInputs = [
      ppxlib
      time_now
    ];
    doCheck = false; # test build rules broken
  };

  ppx_jane = janePackage {
    pname = "ppx_jane";
    hash = "1kk238fvrcylymwm7xwc7llbyspmx1y662ypq00vy70g112rir7j";
    minimalOCamlVersion = "4.04.2";
    meta = {
      description = "Standard Jane Street ppx rewriters";
      mainProgram = "ppx-jane";
    };
    propagatedBuildInputs = [
      base_quickcheck
      ppx_bin_prot
      ppx_expect
      ppx_fixed_literal
      ppx_module_timer
      ppx_optcomp
      ppx_optional
      ppx_pipebang
      ppx_stable
      ppx_string
      ppx_typerep_conv
      ppx_variants_conv
    ];
  };

  ppx_js_style = janePackage {
    pname = "ppx_js_style";
    version = "0.14.1";
    hash = "16ax6ww9h36xyn9acbm8zxv0ajs344sm37lgj2zd2bvgsqv24kxj";
    minimalOCamlVersion = "4.04.2";
    meta.description = "Code style checker for Jane Street Packages";
    propagatedBuildInputs = [
      octavius
      ppxlib
    ];
  };

  ppx_let = janePackage {
    pname = "ppx_let";
    hash = "1jq3g88xv9g6y9im67hiig3cfn5anwwnq09mp7yn7a86ha5r9w3i";
    minimalOCamlVersion = "4.04.2";
    meta.description = "Monadic let-bindings";
    propagatedBuildInputs = [ ppxlib ];
  };

  ppx_log = janePackage {
    pname = "ppx_log";
    hash = "10hnr5lpww3fw0bnidzngalbgy0j1wvz1g5ki9c9h558pnpvsazr";
    minimalOCamlVersion = "4.08.0";
    meta.description = "Ppx_sexp_message-like extension nodes for lazily rendering log messages";
    propagatedBuildInputs = [
      async_unix
      ppx_jane
      sexplib
    ];
  };

  ppx_module_timer = janePackage {
    pname = "ppx_module_timer";
    hash = "163q1rpblwv82fxwyf0p4j9zpsj0jzvkfmzb03r0l49gqhn89mp6";
    minimalOCamlVersion = "4.04.2";
    meta.description = "Ppx rewriter that records top-level module startup times";
    propagatedBuildInputs = [ time_now ];
  };

  ppx_optcomp = janePackage {
    pname = "ppx_optcomp";
    version = "0.14.3";
    hash = "1iflgfzs23asw3k6098v84al5zqx59rx2qjw0mhvk56avlx71pkw";
    minimalOCamlVersion = "4.04.2";
    meta.description = "Optional compilation for OCaml";
    propagatedBuildInputs = [ ppxlib ];
  };

  ppx_optional = janePackage {
    pname = "ppx_optional";
    hash = "1d7rsdqiccxp2w4ykb9klarddm2qrrym3brbnhzx2hm78iyj3hzv";
    minimalOCamlVersion = "4.04.2";
    meta.description = "Pattern matching on flat options";
    propagatedBuildInputs = [ ppxlib ];
  };

  ppx_pattern_bind = janePackage {
    pname = "ppx_pattern_bind";
    hash = "0yxkwnn30nxgrspi191zma95bgrh134aqh2bnpj3wg0245ki55zv";
    minimalOCamlVersion = "4.07";
    meta.description = "PPX for writing fast incremental bind nodes in a pattern match";
    propagatedBuildInputs = [ ppx_let ];
  };

  ppx_pipebang = janePackage {
    pname = "ppx_pipebang";
    hash = "0450b3p2rpnnn5yyvbkcd3c33jr2z0dp8blwxddaj2lv7nzl5dzf";
    minimalOCamlVersion = "4.04.2";
    meta.description = "PPX rewriter that inlines reverse application operators `|>` and `|!`";
    propagatedBuildInputs = [ ppxlib ];
  };

  ppx_python = janePackage {
    pname = "ppx_python";
    hash = "0gk4nqz4i9v3hwjg5mvgpgwj0dfcgpyc7ikba93cafyhn6fy83zk";
    meta.description = "[@@deriving] plugin to generate Python conversion functions";
    # Compatibility with ppxlib 0.23
    patches = fetchpatch {
      url = "https://github.com/janestreet/ppx_python/commit/b2fe0040cc39fa6164de868f8a20edb38d81170e.patch";
      sha256 = "sha256:1mrdwp0zw3dqavzx3ffrmzq5cdlninyf67ksavfzxb8gb16w6zpz";
    };
    propagatedBuildInputs = [
      ppx_base
      ppxlib
      pyml
    ];
  };

  ppx_sexp_conv = janePackage {
    pname = "ppx_sexp_conv";
    version = "0.14.3";
    minimalOCamlVersion = "4.04.2";
    hash = "0dbri9d00ydi0dw1cavswnqdmhjaaz80vap29ns2lr6mhhlvyjmj";
    meta.description = "[@@deriving] plugin to generate S-expression conversion functions";
    propagatedBuildInputs = [
      (ppxlib.override { version = "0.24.0"; })
      sexplib0
      base
    ];
  };

  ppx_sexp_message = janePackage {
    pname = "ppx_sexp_message";
    version = "0.14.1";
    hash = "1lvsr0d68kakih1ll33hy6dxbjkly6lmky4q6z0h0hrcbd6z48k4";
    minimalOCamlVersion = "4.04.2";
    meta.description = "PPX rewriter for easy construction of s-expressions";
    propagatedBuildInputs = [
      ppx_here
      ppx_sexp_conv
    ];
  };

  ppx_sexp_value = janePackage {
    pname = "ppx_sexp_value";
    hash = "1d1c92pyypqkd9473d59j0sfppxvcxggbc62w8bkqnbxrdmvirn9";
    minimalOCamlVersion = "4.04.2";
    meta.description = "PPX rewriter that simplifies building s-expressions from ocaml values";
    propagatedBuildInputs = [
      ppx_here
      ppx_sexp_conv
    ];
  };

  ppx_stable = janePackage {
    pname = "ppx_stable";
    version = "0.14.1";
    hash = "1sp1kn23qr0pfypa4ilvhqq5y11y13xpfygfl582ra9kik5xqfa1";
    minimalOCamlVersion = "4.04.2";
    meta.description = "Stable types conversions generator";
    propagatedBuildInputs = [ ppxlib ];
  };

  ppx_string = janePackage {
    pname = "ppx_string";
    version = "0.14.1";
    minimalOCamlVersion = "4.04.2";
    hash = "0a8khmg0y32kyn3q6idwgh0d6d1s6ms1w75gj3dzng0v7y4h6jx4";
    meta.description = "Ppx extension for string interpolation";
    propagatedBuildInputs = [
      ppx_base
      ppxlib
      stdio
    ];
  };

  ppx_typerep_conv = janePackage {
    pname = "ppx_typerep_conv";
    version = "0.14.2";
    minimalOCamlVersion = "4.04.2";
    hash = "0yk9vkpnwr8labgfncqdi4rfkj88d8mb3cr8m4gdqpi3f2r27hf0";
    meta.description = "Generation of runtime types from type declarations";
    propagatedBuildInputs = [
      ppxlib
      typerep
    ];
  };

  ppx_variants_conv = janePackage {
    pname = "ppx_variants_conv";
    version = "0.14.2";
    minimalOCamlVersion = "4.04.2";
    hash = "1p11fiz4m160hs0xzg4g9rxchp053sz3s3d1lyciqixad1xi47a4";
    meta.description = "Generation of accessor and iteration functions for ocaml variant types";
    propagatedBuildInputs = [
      variantslib
      ppxlib
    ];
  };

  protocol_version_header = janePackage {
    pname = "protocol_version_header";
    hash = "0lfblv2yqw01bl074ga6vxii0p9mqwlqw1g9b9z7pfdva9wqilrd";
    meta.description = "Protocol versioning";
    propagatedBuildInputs = [ core_kernel ];
  };

  pythonlib = janePackage {
    pname = "pythonlib";
    hash = "0qr0mh9jiv1ham5zlz9i4im23a1vh6x1yp6dp2db2s4icmfph639";
    meta.description = "Library to help writing wrappers around ocaml code for python";
    meta.broken = lib.versionAtLeast ocaml.version "4.13";
    propagatedBuildInputs = [
      ppx_expect
      ppx_let
      ppx_python
      stdio
      typerep
    ];
  };

  re2 = janePackage {
    pname = "re2";
    hash = "1j7dizls6lkz3i9dgf8nq2fm382mfbrmz72ci066zl3hkgdq8xwc";
    meta.description = "OCaml bindings for RE2, Google's regular expression library";
    propagatedBuildInputs = [ core_kernel ];
    prePatch = ''
      substituteInPlace src/re2_c/dune --replace 'CXX=g++' 'CXX=c++'
      substituteInPlace src/dune --replace '(cxx_flags (:standard \ -pedantic) (-I re2_c/libre2))' '(cxx_flags (:standard \ -pedantic) (-I re2_c/libre2) (-x c++))'
    '';
  };

  re2_stable = janePackage {
    pname = "re2_stable";
    hash = "0kjc0ff6b3509s3b9n4q8ilb06d5fngdh3z58cm95vg7zkcas9w3";
    meta.description = "Re2_stable adds an incomplete but stable serialization of Re2";
    propagatedBuildInputs = [
      core
      re2
    ];
  };

  resource_cache = janePackage {
    pname = "resource_cache";
    hash = "197z9s535q74h00365ydhggg7hyzpyqvislgwwyi69sl1vy6dr0j";
    meta.description = "General resource cache";
    propagatedBuildInputs = [ async_rpc_kernel ];
  };

  sexp = janePackage {
    pname = "sexp";
    hash = "1x08pyrkd78233kgj70wxlc79w6jjhfrjdamm2xr7jzdc8ycfigf";
    propagatedBuildInputs = [
      async
      core
      csvfields
      re2
      sexp_diff_kernel
      sexp_macro
      sexp_pretty
      sexp_select
    ];
    patches = ./sexp.patch;
    meta.description = "S-expression swiss knife";
    meta.broken = true; # Does not build with GCC 14
  };

  sexp_diff_kernel = janePackage {
    pname = "sexp_diff_kernel";
    hash = "1pljcs019hs2ffhhb7rjh3xz7cbrk8vsv967jzmip3rv9w21c9kh";
    propagatedBuildInputs = [ core_kernel ];
    meta.description = "Code for computing the diff of two sexps";
  };

  sexp_macro = janePackage {
    pname = "sexp_macro";
    hash = "1ih1g7vpb1j8vhzm9a5mjrrzgqrhjqdhf6vjrg8kxfqg5i5b8nyx";
    propagatedBuildInputs = [
      async
      sexplib
    ];
    meta.description = "Sexp macros";
  };

  sexp_pretty = janePackage {
    pname = "sexp_pretty";
    hash = "0dax0wm511zgvr7p6kcd5gygi58118by7hsv7hymy8ldfcky5cwd";
    minimalOCamlVersion = "4.07";
    meta.description = "S-expression pretty-printer";
    propagatedBuildInputs = [
      ppx_base
      re
      sexplib
    ];
  };

  sexp_select = janePackage {
    pname = "sexp_select";
    hash = "1lchhfqw4afw38fnarwylqc2qp7k6xwx3j7m9gy8ygjgd0vgd729";
    minimalOCamlVersion = "4.07";
    propagatedBuildInputs = [
      base
      ppx_jane
    ];
    meta.description = "Library to use CSS-style selectors to traverse sexp trees";
  };

  sexplib0 = janePackage {
    pname = "sexplib0";
    hash = "06sb3zqhb3dwqsmn15d769hfgqwqhxnm52iqim9l767gvlwpmibb";
    minimalOCamlVersion = "4.04.2";
    meta.description = "Library containing the definition of S-expressions and some base converters";
  };

  sexplib = janePackage {
    pname = "sexplib";
    hash = "03c3j1ihx4pjbb0x3arrcif3wvp3iva2ivnywhiak4mbbslgsnzr";
    minimalOCamlVersion = "4.04.2";
    meta.description = "Library for serializing OCaml values to and from S-expressions";
    propagatedBuildInputs = [
      num
      parsexp
    ];
  };

  shell = janePackage {
    pname = "shell";
    hash = "1c4zmpf6s1lk7nficip32c324if6zhm62h9h03d84zgvhvymi0r1";
    meta.description = "Yet another implementation of fork&exec and related functionality";
    buildInputs = [ jst-config ];
    propagatedBuildInputs = [ textutils ];
    checkInputs = [ ounit ];
    doCheck = false; # Does not build with GCC 14
  };

  shexp = janePackage {
    pname = "shexp";
    hash = "1h6hsnbg6bk32f8iv6kd6im4mv2pjsjpd1mjsfx80p1n9273xack";
    minimalOCamlVersion = "4.07";
    propagatedBuildInputs = [
      posixat
      spawn
    ];
    meta.description = "Process library and s-expression based shell";
  };

  spawn = janePackage {
    pname = "spawn";
    version = "0.13.0";
    minimalOCamlVersion = "4.02.3";
    hash = "1w003k1kw1lmyiqlk58gkxx8rac7dchiqlz6ah7aj7bh49b36ppf";
    meta.description = "Spawning sub-processes";
    buildInputs = [ ppx_expect ];
    doCheck = false; # tests are broken on NixOS (absolute paths)
  };

  splay_tree = janePackage {
    pname = "splay_tree";
    hash = "1xbzzbqb054hl1v1zcgfwdgzqihni3a0dmvrric9xggmgn4ycmqq";
    meta.description = "Splay tree implementation";
    propagatedBuildInputs = [ core_kernel ];
  };

  splittable_random = janePackage {
    pname = "splittable_random";
    hash = "0ax988b1wc7km8khg4s6iphbz16y1rssh7baigxfyw3ldp0agk14";
    meta.description = "PRNG that can be split into independent streams";
    propagatedBuildInputs = [
      base
      ppx_assert
      ppx_bench
      ppx_sexp_message
    ];
  };

  stdio = janePackage {
    pname = "stdio";
    hash = "0vv6d8absy4hvjd1babv7avpsdlvjpnd5hq691h39d0h3pvs6l98";
    minimalOCamlVersion = "4.04.2";
    meta.description = "Standard IO library for OCaml";
    propagatedBuildInputs = [ base ];
  };

  textutils = janePackage {
    pname = "textutils";
    hash = "1ggd0530lc5dkc419y3xw1wb52b4b5j3z78991gn5yxf2s50a8d4";
    meta.description = "Text output utilities";
    propagatedBuildInputs = [ core ];
  };

  time_now = janePackage {
    pname = "time_now";
    hash = "1lyq8zdz93hvpi4hpxh88kds30k5ljil8js9clcqyxrldp5n9mw0";
    minimalOCamlVersion = "4.04.2";
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

  timezone = janePackage {
    pname = "timezone";
    hash = "0zf075k94nk2wxnzpxia7pnm655damwp1b58xf2s9disia1ydxg7";
    meta.description = "Time-zone handling";
    propagatedBuildInputs = [ core_kernel ];
  };

  topological_sort = janePackage {
    pname = "topological_sort";
    hash = "17iz7956zln31p0xnm3jlhj863zi84bcx41jylzf7gk23qsm95m8";
    meta.description = "Topological sort algorithm";
    propagatedBuildInputs = [
      ppx_jane
      stdio
    ];
  };

  typerep = janePackage {
    pname = "typerep";
    hash = "0wc7h853ka3s3lxxgm61ypidl0lzgc9abdkil6f72anl0c417y90";
    minimalOCamlVersion = "4.04.2";
    meta.description = "Typerep is a library for runtime types";
    propagatedBuildInputs = [ base ];
  };

  variantslib = janePackage {
    pname = "variantslib";
    hash = "0vy0hpiaawmydh08nqlwjx52pasp74383yi0pshwbdxin99n9mxd";
    minimalOCamlVersion = "4.04.2";
    meta.description = "Part of Jane Street's Core library";
    propagatedBuildInputs = [ base ];
  };

  vcaml = janePackage {
    pname = "vcaml";
    hash = "0ykwrn8bvwx26ad4wb36jw9xnlwsdpnnx88396laxvcfimrp13qs";
    meta.description = "OCaml bindings for the Neovim API";
    propagatedBuildInputs = [
      angstrom-async
      async_extra
      faraday
    ];
  };

  virtual_dom = janePackage {
    pname = "virtual_dom";
    hash = "0vcydxx0jhbd5hbriahgp947mc7n3xymyrsfny1c4adk6aaq3c5w";
    meta.description = "OCaml bindings for the virtual-dom library";
    buildInputs = [ js_of_ocaml-ppx ];
    propagatedBuildInputs = [
      core_kernel
      js_of_ocaml
      lambdasoup
      tyxml
    ];
  };

  zarith_stubs_js = janePackage {
    pname = "zarith_stubs_js";
    hash = "16p4bn5spkrx31fr4np945v9mwdq55706v3wl19s5fy6x83gvb86";
    minimalOCamlVersion = "4.04.2";
    meta.description = "Javascripts stubs for the Zarith library";
    doCheck = false; # requires workspace with zarith
  };

  zstandard = janePackage {
    pname = "zstandard";
    hash = "1vf76v5m9wsh5f77w9z4i8sxm05wr5digyi95x4wvzdi7q3qg6m8";
    meta.description = "OCaml bindings to Zstandard";
    buildInputs = [ ppx_jane ];
    propagatedBuildInputs = [
      core
      ctypes
      zstd
    ];
  };

}
