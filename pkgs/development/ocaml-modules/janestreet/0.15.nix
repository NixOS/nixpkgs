{ self
, fetchpatch
, lib
, openssl
, zstd
}:

with self;

{

  abstract_algebra = janePackage {
    pname = "abstract_algebra";
    minimumOCamlVersion = "4.08";
    hash = "12imf6ibm7qb8r1fpqnrl20x2z14zl3ri1vzg0z8qby9l8bv2fbd";
    meta.description = "A small library describing abstract algebra concepts";
    propagatedBuildInputs = [ base ppx_jane ];
  };

  accessor = janePackage {
    pname = "accessor";
    minimumOCamlVersion = "4.09";
    hash = "17rzf0jpc9s3yrxcnn630jhgsw5mrnrhwbfh62hqxqanascc5rxh";
    meta.description = "A library that makes it nicer to work with nested functional data structures";
    propagatedBuildInputs = [ higher_kinded ];
  };

  accessor_async = janePackage {
    pname = "accessor_async";
    minimumOCamlVersion = "4.09";
    hash = "17r6af55ms0i496jsfx0xpdm336c2vhyf49b3s8s1gpz521wrgmc";
    meta.description = "Accessors for Async types, for use with the Accessor library";
    propagatedBuildInputs = [ accessor_core async_kernel ];
  };

  accessor_base = janePackage {
    pname = "accessor_base";
    minimumOCamlVersion = "4.09";
    hash = "1qvq005vxf6n1c7swzb4bzcqdh471bfb9gcmdj4m57xg85xznc1n";
    meta.description = "Accessors for Base types, for use with the Accessor library";
    propagatedBuildInputs = [ ppx_accessor ];
  };

  accessor_core = janePackage {
    minimumOCamlVersion = "4.09";
    pname = "accessor_core";
    hash = "0zrs5zbyrhfbah73g22l19bw1mmljhyb3l2mrwcxgbjq9pqp0k9v";
    meta.description = "Accessors for Core types, for use with the Accessor library";
    propagatedBuildInputs = [ accessor_base core_kernel ];
  };

  async = janePackage {
    pname = "async";
    hash = "0pykmnsil754jsnr8gss91ykyjvivngx4ii0ih3nsg1x2jl9xmy2";
    meta.description = "Monadic concurrency library";
    propagatedBuildInputs = [ async_rpc_kernel async_unix textutils ];
    doCheck = false; # we don't have netkit_sockets
  };

  async_extra = janePackage {
    pname = "async_extra";
    hash = "0pxp0b4shz9krsj8xfzajv8a1mijgf0xdgxrn2abdqrz3rvj6pig";
    meta.description = "Monadic concurrency library";
    propagatedBuildInputs = [ async_kernel ];
  };

  async_find = janePackage {
    pname = "async_find";
    hash = "119988nkcnw6l6wch4llqkvsrawv2gkbn5q4hngpdwvnw0g0aapv";
    meta.description = "Directory traversal with Async";
    propagatedBuildInputs = [ async ];
  };

  async_inotify = janePackage {
    pname = "async_inotify";
    hash = "1nxz6bijp7liy18ljrxg92v2m8v8fqcs1pmzg9kbcf0d4vij8j2p";
    meta.description = "Async wrapper for inotify";
    propagatedBuildInputs = [ async_find inotify ];
  };

  async_interactive = janePackage {
    pname = "async_interactive";
    hash = "00hr2lhs8p3hwnyllmns59rwlpimc5b7r6v4zn6cmpb1riblaxqp";
    meta.description = "Utilities for building simple command-line based user interfaces";
    propagatedBuildInputs = [ async ];
  };

  async_js = janePackage {
    pname = "async_js";
    hash = "184j077bz686k5lrqswircnrdqldb316ngpzq7xri1pcsl39sy3q";
    meta.description = "A small library that provide Async support for JavaScript platforms";
    buildInputs = [ js_of_ocaml-ppx ];
    propagatedBuildInputs = [ async_rpc_kernel js_of_ocaml uri-sexp ];
  };

  async_kernel = janePackage {
    pname = "async_kernel";
    hash = "01if6c8l2h64v7sk56xr8acnmj6g9whxcjrzzzvczspq88hq2bfh";
    meta.description = "Monadic concurrency library";
    propagatedBuildInputs = [ core_kernel ];
  };

  async_rpc_kernel = janePackage {
    pname = "async_rpc_kernel";
    hash = "1b5rp5yam03ir4f1sixpzjg1zdqmkb7lvnaa82kac4fzk80gfrfr";
    meta.description = "Platform-independent core of Async RPC library";
    propagatedBuildInputs = [ async_kernel protocol_version_header ];
  };

  async_rpc_websocket = janePackage {
    pname = "async_rpc_websocket";
    hash = "1n93jhkz5r76xcc40c4i4sxcyfz1dbppz8sjfxpwcwjyi6lyhp1p";
    meta.description = "Library to serve and dispatch Async RPCs over websockets";
    propagatedBuildInputs = [ async_rpc_kernel async_websocket cohttp_async_websocket ];
  };

  async_sendfile = janePackage {
    pname = "async_sendfile";
    hash = "0lnagdxfnac4z29narphf2ab5a23ys883zmc45r96rssfx82i3fs";
    meta.description = "Thin wrapper around [Linux_ext.sendfile] to send full files";
    propagatedBuildInputs = [ async_unix ];
  };

  async_shell = janePackage {
    pname = "async_shell";
    hash = "07iwlyrc4smk6hsnz89cz2ihp670mllq0y9wbdafvagm1y1p62vx";
    meta.description = "Shell helpers for Async";
    propagatedBuildInputs = [ async shell ];
  };

  async_smtp = janePackage {
    pname = "async_smtp";
    hash = "1m00j7wcb0blipnc1m6by70gd96a1k621b4dgvgffp8as04a461r";
    minimumOCamlVersion = "4.12";
    meta.description = "SMTP client and server";
    propagatedBuildInputs = [ async_extra async_inotify async_sendfile async_shell async_ssl email_message resource_cache re2_stable sexp_macro ];
  };

  async_ssl = janePackage {
    pname = "async_ssl";
    hash = "1b7f7p3xj4jr2n2dxy2lp7a9k7944w6x2nrg6524clvcsd1ax4hn";
    meta.description = "Async wrappers for SSL";
    buildInputs = [ dune-configurator ];
    propagatedBuildInputs = [ async ctypes openssl ];
    # in ctypes.foreign 0.18.0 threaded and unthreaded have been merged
    postPatch = ''
      substituteInPlace bindings/dune \
        --replace "ctypes.foreign.threaded" "ctypes.foreign"
    '';
  };

  async_unix = janePackage {
    pname = "async_unix";
    hash = "0z4fgpn93iw0abd7l9kac28qgzgc5qr2x0s1n2zh49lsdn02n6ys";
    meta.description = "Monadic concurrency library";
    propagatedBuildInputs = [ async_kernel core_unix ];
  };

  async_websocket = janePackage {
    pname = "async_websocket";
    hash = "16ixqfnx9jp77bvx11dlzsq0pzfpyiif60hl2q06zncyswky9xgb";
    meta.description = "A library that implements the websocket protocol on top of Async";
    propagatedBuildInputs = [ async cryptokit ];
  };

  base = janePackage {
    pname = "base";
    hash = "1qyycqqr4dijvxm4hhy79c964wd91kpsfvb89kna1qwgllg0hrpj";
    minimumOCamlVersion = "4.10";
    meta.description = "Full standard library replacement for OCaml";
    buildInputs = [ dune-configurator ];
    propagatedBuildInputs = [ sexplib0 ];
    checkInputs = [ alcotest ];
  };

  base_bigstring = janePackage {
    pname = "base_bigstring";
    hash = "1hv3hw2fwqmkrxms1g6rw3c18mmla1z5bva3anx45mnff903iv4q";
    minimumOCamlVersion = "4.08";
    meta.description = "String type based on [Bigarray], for use in I/O and C-bindings";
    propagatedBuildInputs = [ int_repr ppx_jane ];
  };

  base_quickcheck = janePackage {
    pname = "base_quickcheck";
    hash = "0q73kfr67cz5wp4qn4rq3lpa922hqmvwdiinnans0js65fvlgqsi";
    minimumOCamlVersion = "4.04.2";
    meta.description = "Randomized testing framework, designed for compatibility with Base";
    propagatedBuildInputs = [ ppx_base ppx_fields_conv ppx_let ppx_sexp_value splittable_random ];
  };

  bignum = janePackage {
    pname = "bignum";
    hash = "12q3xcv78b4s9srnc17jbyn53d5drmwmyvgp62p7nk3fs4f7cr4f";
    propagatedBuildInputs = [ core_kernel zarith zarith_stubs_js ];
    meta.description = "Core-flavoured wrapper around zarith's arbitrary-precision rationals";
  };

  bin_prot = janePackage {
    pname = "bin_prot";
    hash = "1qfqglscc25wwnjx7byqmjcnjww1msnr8940gyg8h93wdq43fjnh";
    minimumOCamlVersion = "4.04.2";
    meta.description = "A binary protocol generator";
    propagatedBuildInputs = [ ppx_compare ppx_custom_printf ppx_fields_conv ppx_optcomp ppx_variants_conv ];
  };

  bonsai = janePackage {
    pname = "bonsai";
    hash = "150zx2g1dmhyrxwqq8j7f2m3hjpmk5bk182ihx2gdbarhw1ainpm";
    meta.description = "A library for building dynamic webapps, using Js_of_ocaml";
    buildInputs = [ ppx_pattern_bind ];
    nativeBuildInputs = [ js_of_ocaml-compiler ocaml-embed-file ];
    propagatedBuildInputs = [
      async
      async_extra
      async_rpc_websocket
      cohttp-async
      core_bench
      fuzzy_match
      incr_dom
      js_of_ocaml-ppx
      patdiff
      ppx_css
      ppx_typed_fields
      profunctor
      textutils
    ];
    patches = [ ./bonsai_jsoo_4_0.patch ];
  };

  cinaps = janePackage {
    pname = "cinaps";
    version = "0.15.1";
    hash = "0g856cxmxg4vicwslhqldplkpwi158s2d62vwzv26xg5m6wjn9rg";
    minimumOCamlVersion = "4.04";
    meta.description = "Trivial metaprogramming tool";
    propagatedBuildInputs = [ re ];
    doCheck = false; # fails because ppx_base doesn't include ppx_js_style
  };

  cohttp_async_websocket = janePackage {
    pname = "cohttp_async_websocket";
    hash = "0d0smavnxpnwrmhlcf3b5a3cm3n9kz1y8fh6l28xv6zrn4sc7ik8";
    meta.description = "Websocket library for use with cohttp and async";
    propagatedBuildInputs = [ async_websocket cohttp-async ppx_jane uri-sexp ];
  };

  core = janePackage {
    pname = "core";
    hash = "1m2ybvlz9zlb2d0jc0j7wdgd18mx9sh3ds2ylkv0cfjx1pzi0l25";
    meta.description = "Industrial strength alternative to OCaml's standard library";
    buildInputs = [ jst-config ];
    propagatedBuildInputs = [ base base_bigstring base_quickcheck ppx_jane time_now ];
    doCheck = false; # circular dependency with core_kernel
  };

  core_bench = janePackage {
    pname = "core_bench";
    hash = "0v6lm9vz6y1qd7h8pg9l5jsy8qr74vlk1nd4qzchld4jhwq7mbdi";
    meta.description = "Benchmarking library";
    propagatedBuildInputs = [ textutils ];
  };

  core_extended = janePackage {
    pname = "core_extended";
    hash = "0sx79hc1y1daczib2p4nbyw4aqnznmdd83knrhs5q153j7lnlalx";
    meta.description = "Extra components that are not as closely vetted or as stable as Core";
    propagatedBuildInputs = [ core_unix record_builder ];
  };

  core_kernel = janePackage {
    pname = "core_kernel";
    hash = "05mb4vbf293iq1xx4acyrmi9cgcw6capwrsa54ils62alby6w6yq";
    meta.description = "System-independent part of Core";
    buildInputs = [ jst-config ];
    propagatedBuildInputs = [ base_bigstring core int_repr sexplib ];
    doCheck = false; # we don't have quickcheck_deprecated
  };

  core_unix = janePackage {
    pname = "core_unix";
    hash = "1xzxqzg23in5ivz0v3qshzpr4w92laayscqj9im7jylh2ar1xi0a";
    meta.description = "Unix-specific portions of Core";
    buildInputs = [ jst-config ];
    propagatedBuildInputs = [ core_kernel expect_test_helpers_core ocaml_intrinsics ppx_jane timezone spawn ];
    postPatch = ''
      patchShebangs unix_pseudo_terminal/src/discover.sh
    '';
  };

  csvfields = janePackage {
    pname = "csvfields";
    hash = "0z47pq17bw776hzvk48ypbd92ps9vlvl86mnhw3j6cqx4ahbjik3";
    propagatedBuildInputs = [ core num ];
    meta.description = "Runtime support for ppx_xml_conv and ppx_csv_conv";
  };

  delimited_parsing = janePackage {
    pname = "delimited_parsing";
    hash = "0d050v58zzi8c4qiwxbfcyrdw6zvncnnl3qj79qi0yq4xkg7820r";
    propagatedBuildInputs = [ async core_extended ];
    meta.description = "Parsing of character (e.g., comma) separated and fixed-width values";
  };

  ecaml = janePackage {
    pname = "ecaml";
    hash = "08g2bl06vkn3bkqzkmvk2646aqb6jj4a7n3wgzpcx1c2gl3iw5i6";
    meta.description = "Library for writing Emacs plugin in OCaml";
    propagatedBuildInputs = [ async expect_test_helpers_core ];
  };

  email_message = janePackage {
    pname = "email_message";
    hash = "00h66l2g5rjaay0hbyqy4v9i866g779miriwv20h9k4mliqdq7in";
    meta.description = "E-mail message parser";
    propagatedBuildInputs = [ angstrom async base64 cryptokit magic-mime re2 ];
  };

  expect_test_helpers_async = janePackage {
    pname = "expect_test_helpers_async";
    hash = "14v4966p5dmqgjb9sgrvnsixv0w0bagicn8v44g9mf9d88z8pfym";
    meta.description = "Async helpers for writing expectation tests";
    propagatedBuildInputs = [ async expect_test_helpers_core ];
  };

  expect_test_helpers_core = janePackage {
    pname = "expect_test_helpers_core";
    hash = "0bxs3g0zzym8agfcbpg5lmrh6hcb86z861bq40xhhfwqf4pzdbfa";
    meta.description = "Helpers for writing expectation tests";
    propagatedBuildInputs = [ core_kernel sexp_pretty ];
  };

  fieldslib = janePackage {
    pname = "fieldslib";
    hash = "0xwf9mdxlyr3f0vv5y82cyw2bsckwl8rwf6jm6bai1gqpgxjq756";
    minimumOCamlVersion = "4.04.2";
    meta.description = "Syntax extension to define first class values representing record fields, to get and set record fields, iterate and fold over all fields of a record and create new record values";
    propagatedBuildInputs = [ base ];
  };

  fuzzy_match = janePackage {
    pname = "fuzzy_match";
    hash = "0s5w81698b07l5m11nwx8xbjcpmp54dnf5fcrnlva22jrlsf14h4";
    meta.description = "A library for fuzzy string matching";
    propagatedBuildInputs = [ core ppx_jane ];
  };

  higher_kinded = janePackage {
    pname = "higher_kinded";
    minimumOCamlVersion = "4.09";
    hash = "0rafxxajqswi070h8sinhjna0swh1hc6d7i3q7y099yj3wlr2y1l";
    meta.description = "A library with an encoding of higher kinded types in OCaml";
    propagatedBuildInputs = [ base ppx_jane ];
  };

  incr_dom = janePackage {
    pname = "incr_dom";
    hash = "1sija9w2im8vdp61h387w0mww9hh7jgkgsjcccps4lbv936ac7c1";
    meta.description = "A library for building dynamic webapps, using Js_of_ocaml";
    buildInputs = [ js_of_ocaml-ppx ];
    propagatedBuildInputs = [ async_js incr_map incr_select virtual_dom ];
    patches = [ ./incr_dom_jsoo_4_0.patch ];
  };

  incr_map = janePackage {
    pname = "incr_map";
    hash = "0aq8wfylvq68him92vzh1fqmr7r0lfwc5cdiqr10r5x032vzpnii";
    meta.description = "Helpers for incremental operations on map like data structures";
    buildInputs = [ ppx_pattern_bind ];
    propagatedBuildInputs = [ abstract_algebra incremental ];
  };

  incr_select = janePackage {
    pname = "incr_select";
    hash = "0qm2i4hb5jh2ra95kq881s4chkwbd2prvql1c0nahd63h829m57l";
    meta.description = "Handling of large set of incremental outputs from a single input";
    propagatedBuildInputs = [ incremental ];
  };

  incremental = janePackage {
    pname = "incremental";
    hash = "1dp30mhljnbcxqimydwbmxx0x4y4xnb55gyhldm1f5qrwdxdl747";
    meta.description = "Library for incremental computations";
    propagatedBuildInputs = [ core_kernel ];
  };

  int_repr = janePackage {
    pname = "int_repr";
    hash = "0ph88ym3s9dk30n17si2xam40sp8wv1xffw5cl3bskc2vfya1nvl";
    meta.description = "Integers of various widths";
    propagatedBuildInputs = [ base ppx_jane ];
  };

  jane-street-headers = janePackage {
    pname = "jane-street-headers";
    hash = "1lzk3w66x4429n2j75lwm55xafc46mywgdrbh9nc9jwqwgzf0wwx";
    minimumOCamlVersion = "4.04.2";
    meta.description = "Jane Street C header files";
  };

  jsonaf = janePackage {
    pname = "jsonaf";
    hash = "1j9rn8vsvfpgmdpmdqb5qhvss5171j8n3ii1bcgnavqinchbvqa6";
    meta.description = "A library for parsing, manipulating, and serializing data structured as JSON";
    propagatedBuildInputs = [ base ppx_jane angstrom faraday ];
  };

  jst-config = janePackage {
    pname = "jst-config";
    hash = "1lxqsj5k3v8p7g802vj1xc6bs5wrfpszh3q61xvpcd42pf3ahma9";
    meta.description = "Compile-time configuration for Jane Street libraries";
    buildInputs = [ dune-configurator ppx_assert stdio ];
    patches = [
      # remove on next release
      (fetchpatch {
        url = "https://github.com/janestreet/jst-config/commit/e5fdac6e5df9ba93e014a4d2db841fdbf209446f.patch";
        sha256 = "sha256-8hVC76z5ilYD/++xRHVswy/l+zzDt63jH4hfSJ/rPaA=";
      })
    ];
  };

  ocaml-compiler-libs = janePackage {
    pname = "ocaml-compiler-libs";
    version = "0.12.4";
    minimumOCamlVersion = "4.04.1";
    hash = "00if2f7j9d8igdkj4rck3p74y17j6b233l91mq02drzrxj199qjv";
    meta.description = "OCaml compiler libraries repackaged";
  };

  ocaml-embed-file = janePackage {
    pname = "ocaml-embed-file";
    hash = "1nzgc0q05f0j3q1kwfpyhhhpgwrfjvmkqqifrkrm4y7d1i44bfnw";
    propagatedBuildInputs = [ async ppx_jane ];
    meta.description = "Files contents as module constants";
  };

  ocaml_intrinsics = janePackage {
    pname = "ocaml_intrinsics";
    minimumOCamlVersion = "4.08";
    version = "0.15.2";
    hash = "sha256-f5zqrKaokj1aEvbu7lOuK0RoWSklFr6QFpV+oWbIX9U=";
    meta.description = "Intrinsics";
    buildInputs = [ dune-configurator ];
    doCheck = false; # test rules broken
  };

  parsexp = janePackage {
    pname = "parsexp";
    hash = "1grzpxi39318vcqhwf723hqh11k68irh59zb3dyg9lw8wjn7752a";
    minimumOCamlVersion = "4.04.2";
    meta.description = "S-expression parsing library";
    propagatedBuildInputs = [ base sexplib0 ];
  };

  patdiff = janePackage {
    pname = "patdiff";
    hash = "0623a7n5r659rkxbp96g361mvxkcgc6x9lcbkm3glnppplk5kxr9";
    propagatedBuildInputs = [ core_unix patience_diff ocaml_pcre ];
    meta = {
      description = "File Diff using the Patience Diff algorithm";
    };
  };

  patience_diff = janePackage {
    pname = "patience_diff";
    hash = "17yrhn4qfi31m8g1ygb3m6i9z4fqd8f60fn6viazgx06s3x4xp3v";
    meta.description = "Diff library using Bram Cohen's patience diff algorithm";
    propagatedBuildInputs = [ core_kernel ];
  };

  posixat = janePackage {
    pname = "posixat";
    hash = "1xgycwa0janrfn9psb7xrm0820blr82mqf1lvjy9ipqalj7v9w1f";
    minimumOCamlVersion = "4.07";
    propagatedBuildInputs = [ ppx_optcomp ppx_sexp_conv ];
    meta.description = "Binding to the posix *at functions";
  };

  ppx_accessor = janePackage {
    pname = "ppx_accessor";
    minimumOCamlVersion = "4.09";
    hash = "0qv51if1nk0zff2v6q946h8ac7bpd5xa4ivyixl9g4h2mk29w4qb";
    meta.description = "[@@deriving] plugin to generate accessors for use with the Accessor libraries";
    propagatedBuildInputs = [ accessor ];
  };

  ppx_assert = janePackage {
    pname = "ppx_assert";
    hash = "0dic250q3flrjs3i70a2qqqnhqqj75ddlixpy7hdfghjw32azw90";
    minimumOCamlVersion = "4.04.2";
    meta.description = "Assert-like extension nodes that raise useful errors on failure";
    propagatedBuildInputs = [ ppx_cold ppx_compare ppx_here ppx_sexp_conv ];
  };

  ppx_base = janePackage {
    pname = "ppx_base";
    hash = "13rfmy2fxvwi7z5l1mai474ri5anqjm8q4hs7dblplsjjd9m5ld1";
    minimumOCamlVersion = "4.04.2";
    meta.description = "Base set of ppx rewriters";
    propagatedBuildInputs = [ ppx_cold ppx_enumerate ppx_hash ];
  };

  ppx_bench = janePackage {
    pname = "ppx_bench";
    hash = "0bc0gbm922417wqisafxh35jslcp7xy1s0h0a1q32rhx0ivxx3g6";
    minimumOCamlVersion = "4.04.2";
    meta.description = "Syntax extension for writing in-line benchmarks in ocaml code";
    propagatedBuildInputs = [ ppx_inline_test ];
  };

  ppx_bin_prot = janePackage {
    pname = "ppx_bin_prot";
    hash = "1280wsls061fmvmdysjqn3lv4mnkyg400jnjf4jyfr14s33h1ad5";
    minimumOCamlVersion = "4.04.2";
    meta.description = "Generation of bin_prot readers and writers from types";
    propagatedBuildInputs = [ bin_prot ppx_here ];
    doCheck = false; # circular dependency with ppx_jane
  };

  ppx_cold = janePackage {
    pname = "ppx_cold";
    hash = "0x7xgpvy0l28k971xy08ibhr4w9nh8d9zvxc6jfxxx4fbfcv5gca";
    minimumOCamlVersion = "4.04.2";
    meta.description = "Expands [@cold] into [@inline never][@specialise never][@local never]";
    propagatedBuildInputs = [ ppxlib ];
  };

  ppx_compare = janePackage {
    pname = "ppx_compare";
    hash = "1wjwqkr71p61vjidbr80l93y4kkad7xsfyp04w8qfqrj7h5nm625";
    minimumOCamlVersion = "4.04.2";
    meta.description = "Generation of comparison functions from types";
    propagatedBuildInputs = [ ppxlib base ];
  };

  ppx_custom_printf = janePackage {
    pname = "ppx_custom_printf";
    hash = "1k8nmq6kwqz2wpkm9ymq749dz1vd8lxrjc711knp1wyz5935hnsv";
    minimumOCamlVersion = "4.04.2";
    meta.description = "Printf-style format-strings for user-defined string conversion";
    propagatedBuildInputs = [ ppx_sexp_conv ];
  };

  ppx_css = janePackage {
    pname = "ppx_css";
    hash = "09dpmj3f3m3z1ji9hq775iqr3cfmv5gh7q9zlblizj4wx4y0ibyi";
    meta.description = "A ppx that takes in css strings and produces a module for accessing the unique names defined within";
    propagatedBuildInputs = [ core_kernel ppxlib js_of_ocaml js_of_ocaml-ppx sedlex ];
  };

  ppx_disable_unused_warnings = janePackage {
    pname = "ppx_disable_unused_warnings";
    hash = "0sb5i4v7p9df2bxk66rjs30k9fqdrwsq1jgykjv6wyrx2d9bv955";
    minimumOCamlVersion = "4.04.2";
    meta.description = "Expands [@disable_unused_warnings] into [@warning \"-20-26-32-33-34-35-36-37-38-39-60-66-67\"]";
    propagatedBuildInputs = [ ppxlib ];
  };

  ppx_enumerate = janePackage {
    pname = "ppx_enumerate";
    hash = "1i0f6jv5cappw3idd70wpg76d7x6mvxapa89kri1bwz47hhg4pkz";
    minimumOCamlVersion = "4.04.2";
    meta.description = "Generate a list containing all values of a finite type";
    propagatedBuildInputs = [ ppxlib ];
  };

  ppx_expect = janePackage {
    pname = "ppx_expect";
    hash = "134dl5qhjxsj2mcmrx9f3m0iys0n5mjfpz9flj8zn8d2jir43776";
    minimumOCamlVersion = "4.04.2";
    meta.description = "Cram like framework for OCaml";
    propagatedBuildInputs = [ ppx_here ppx_inline_test re ];
    doCheck = false; # test build rules broken
  };

  ppx_fields_conv = janePackage {
    pname = "ppx_fields_conv";
    hash = "094wsnw7fcwgl9xg6vkjb0wbgpn9scsp847yhdd184sz9v1amz14";
    minimumOCamlVersion = "4.04.2";
    meta.description = "Generation of accessor and iteration functions for ocaml records";
    propagatedBuildInputs = [ fieldslib ppxlib ];
  };

  ppx_fixed_literal = janePackage {
    pname = "ppx_fixed_literal";
    hash = "10siwcqrqa4gh0mg6fkaby0jjskc01r81pcblc67h3vmbjjh08j9";
    minimumOCamlVersion = "4.04.2";
    meta.description = "Simpler notation for fixed point literals";
    propagatedBuildInputs = [ ppxlib ];
  };

  ppx_hash = janePackage {
    pname = "ppx_hash";
    hash = "15agkwavadllzxdv4syjna02083nfnap8qs4yqf5s0adjw73fzyg";
    minimumOCamlVersion = "4.04.2";
    meta.description = "A ppx rewriter that generates hash functions from type expressions and definitions";
    propagatedBuildInputs = [ ppx_compare ppx_sexp_conv ];
  };

  ppx_here = janePackage {
    pname = "ppx_here";
    hash = "0jv81k8x18q8rxdyfwavrvx8yq9k5m3abpmgdg6zipx2ajcjzvag";
    minimumOCamlVersion = "4.04.2";
    meta.description = "Expands [%here] into its location";
    propagatedBuildInputs = [ ppxlib ];
    doCheck = false; # test build rules broken
  };

  ppx_ignore_instrumentation = janePackage {
    pname = "ppx_ignore_instrumentation";
    hash = "16fgig88g3jr0m3i636fr52h29h1yzhi8nhnl4029zn808kcdyj2";
    minimumOCamlVersion = "4.08";
    meta.description = "Ignore Jane Street specific instrumentation extensions";
    propagatedBuildInputs = [ ppxlib ];
  };

  ppx_inline_test = janePackage {
    pname = "ppx_inline_test";
    hash = "1a0gaj9p6gbn5j7c258mnzr7yjlq0hqi3aqqgyj1g2dbk1sxdbjz";
    minimumOCamlVersion = "4.04.2";
    meta.description = "Syntax extension for writing in-line tests in ocaml code";
    propagatedBuildInputs = [ ppxlib time_now ];
    doCheck = false; # test build rules broken
  };

  ppx_jane = janePackage {
    pname = "ppx_jane";
    hash = "1p6847gdfnnj6qpa4yh57s6wwpsl7rfgy0q7993chz24h9mhz5lk";
    minimumOCamlVersion = "4.04.2";
    meta.description = "Standard Jane Street ppx rewriters";
    propagatedBuildInputs = [ base_quickcheck ppx_bin_prot ppx_disable_unused_warnings ppx_expect ppx_fixed_literal ppx_ignore_instrumentation ppx_log ppx_module_timer ppx_optcomp ppx_optional ppx_pipebang ppx_stable ppx_string ppx_typerep_conv ppx_variants_conv ];
  };

  ppx_js_style = janePackage {
    pname = "ppx_js_style";
    hash = "0q2p9pvmlncgv0hprph95xiv7s6q44ynvp4yl4dckf1qx68rb3ba";
    minimumOCamlVersion = "4.04.2";
    meta.description = "Code style checker for Jane Street Packages";
    propagatedBuildInputs = [ octavius ppxlib ];
  };

  ppx_let = janePackage {
    pname = "ppx_let";
    hash = "04v3fq0vnvvavxbc7hfsrg8732pwxbyw8pjl3xfplqdqci6fj15n";
    minimumOCamlVersion = "4.04.2";
    meta.description = "Monadic let-bindings";
    propagatedBuildInputs = [ ppxlib ppx_here ];
  };

  ppx_log = janePackage {
    pname = "ppx_log";
    hash = "08i9gz3f4w3bmlrfdw7ja9awsfkhhldz03bnnc4hijfmn8sawzi0";
    minimumOCamlVersion = "4.08.0";
    meta.description = "Ppx_sexp_message-like extension nodes for lazily rendering log messages";
    propagatedBuildInputs = [ base ppx_here ppx_sexp_conv ppx_sexp_message sexplib ];
  };

  ppx_module_timer = janePackage {
    pname = "ppx_module_timer";
    hash = "0lzi5hxi10p89ddqbrc667267f888kqslal76gfhmszyk60n20av";
    minimumOCamlVersion = "4.04.2";
    meta.description = "Ppx rewriter that records top-level module startup times";
    propagatedBuildInputs = [ time_now ];
  };

  ppx_optcomp = janePackage {
    pname = "ppx_optcomp";
    hash = "0ypivfipi8fcr9pqyvl2ajpcivmr1irdwwv248i4x6mggpc2pl0b";
    minimumOCamlVersion = "4.04.2";
    meta.description = "Optional compilation for OCaml";
    propagatedBuildInputs = [ ppxlib ];
  };

  ppx_optional = janePackage {
    pname = "ppx_optional";
    hash = "0amxwxhkyzamgnxx400qhvxzqr3m4sazhhkc516lm007pynv7xq2";
    minimumOCamlVersion = "4.04.2";
    meta.description = "Pattern matching on flat options";
    propagatedBuildInputs = [ ppxlib ];
  };

  ppx_pattern_bind = janePackage {
    pname = "ppx_pattern_bind";
    hash = "01nfdk9yvk92r7sjl4ngxfsx8fyqh2dsjxz0i299nszv9jc4rn4f";
    minimumOCamlVersion = "4.07";
    meta.description = "A ppx for writing fast incremental bind nodes in a pattern match";
    propagatedBuildInputs = [ ppx_let ];
  };

  ppx_pipebang = janePackage {
    pname = "ppx_pipebang";
    hash = "0sm5dghyalhws3hy1cc2ih36az1k4q02hcgj6l26gwyma3y4irvq";
    minimumOCamlVersion = "4.04.2";
    meta.description = "A ppx rewriter that inlines reverse application operators `|>` and `|!`";
    propagatedBuildInputs = [ ppxlib ];
  };

  ppx_python = janePackage {
    pname = "ppx_python";
    hash = "1d2wf0rkvxg07q6xq2zmxh6hmvnwlsmny3mm92jsg1s7bdl39gap";
    meta.description = "A [@@deriving] plugin to generate Python conversion functions ";
    propagatedBuildInputs = [ ppx_base ppxlib pyml ];
  };

  ppx_sexp_conv = janePackage {
    pname = "ppx_sexp_conv";
    minimumOCamlVersion = "4.04.2";
    hash = "1fyf7hgxprn7pj58rmmrfpv938a0avpzvvk6wzihpmfm6whgbdm8";
    meta.description = "[@@deriving] plugin to generate S-expression conversion functions";
    propagatedBuildInputs = [ ppxlib sexplib0 base ];
  };

  ppx_sexp_message = janePackage {
    pname = "ppx_sexp_message";
    hash = "0a7hx50bkkc5n5msc3zzc4ixnp7674x3mallknb9j31jnd8l90nj";
    minimumOCamlVersion = "4.04.2";
    meta.description = "A ppx rewriter for easy construction of s-expressions";
    propagatedBuildInputs = [ ppx_here ppx_sexp_conv ];
  };

  ppx_sexp_value = janePackage {
    pname = "ppx_sexp_value";
    hash = "0kz83j9v6yz3v8c6vr9ilhkcci4hhjd6i6r6afnx72jh6i7d3hnv";
    minimumOCamlVersion = "4.04.2";
    meta.description = "A ppx rewriter that simplifies building s-expressions from ocaml values";
    propagatedBuildInputs = [ ppx_here ppx_sexp_conv ];
  };

  ppx_stable = janePackage {
    pname = "ppx_stable";
    hash = "1as0v0x8c9ilyhngax55lvwyyi4a2wshyan668v0f2s1608cwb1l";
    minimumOCamlVersion = "4.04.2";
    meta.description = "Stable types conversions generator";
    propagatedBuildInputs = [ ppxlib ];
  };

  ppx_string = janePackage {
    pname = "ppx_string";
    minimumOCamlVersion = "4.04.2";
    hash = "1dp5frk6cig5m3m5rrh2alw63snyf845x7zlkkaljip02pqcbw1s";
    meta.description = "Ppx extension for string interpolation";
    propagatedBuildInputs = [ ppx_base ppxlib stdio ];
  };

  ppx_typed_fields = janePackage {
    pname = "ppx_typed_fields";
    hash = "0hxililjgy4jh66b4xmphrfhv6qpp7dz7xbz3islp357hf18niqy";
    meta.description = "GADT-based field accessors and utilities";
    propagatedBuildInputs = [ core ppx_jane ppxlib ];
  };

  ppx_typerep_conv = janePackage {
    pname = "ppx_typerep_conv";
    minimumOCamlVersion = "4.04.2";
    hash = "1q1lzykpm83ra4l5jh4rfddhd3c96kx4s4rvx0w4b51z1qk56zam";
    meta.description = "Generation of runtime types from type declarations";
    propagatedBuildInputs = [ ppxlib typerep ];
  };

  ppx_variants_conv = janePackage {
    pname = "ppx_variants_conv";
    minimumOCamlVersion = "4.04.2";
    hash = "1dh0bw9dn246k00pymf59yjkl6x6bxd76lkk9b5xpq2692wwlc3s";
    meta.description = "Generation of accessor and iteration functions for ocaml variant types";
    propagatedBuildInputs = [ variantslib ppxlib ];
  };

  profunctor = janePackage {
    pname = "profunctor";
    hash = "151vk0cagjwn0isnnwryn6gmvnpds4dyj1in9jvv5is8yij203gg";
    meta.description = "A library providing a signature for simple profunctors and traversal of a record";
    propagatedBuildInputs = [ base ppx_jane record_builder ];
  };

  protocol_version_header = janePackage {
    pname = "protocol_version_header";
    hash = "0s638cwf1357gg754rc4306654hhrhzqaqm2lp3yv5vj3ml8p4qy";
    meta.description = "Protocol versioning";
    propagatedBuildInputs = [ core_kernel ];
  };

  pythonlib = janePackage {
    pname = "pythonlib";
    hash = "0p88vmp19zmr0r58dz6sawsmbn4yi2vyymad2c82kp93kg66nm1v";
    meta.description = "A library to help writing wrappers around ocaml code for python";
    patches = lib.optional (lib.versionAtLeast ocaml.version "4.13") ./pythonlib.patch;
    propagatedBuildInputs = [ ppx_expect ppx_let ppx_python stdio typerep ];
    meta.broken = lib.versionAtLeast ocaml.version "4.14";
  };

  re2 = janePackage {
    pname = "re2";
    hash = "0z1cajd8abrryf3gz322jpynba79nv4a2kmmcdz0314ran5w68v3";
    meta.description = "OCaml bindings for RE2, Google's regular expression library";
    propagatedBuildInputs = [ core_kernel ];
    prePatch = ''
      substituteInPlace src/re2_c/dune --replace 'CXX=g++' 'CXX=c++'
      substituteInPlace src/dune --replace '(cxx_flags (:standard \ -pedantic) (-I re2_c/libre2))' '(cxx_flags (:standard \ -pedantic) (-I re2_c/libre2) (-x c++))'
    '';
  };

  re2_stable = janePackage {
    pname = "re2_stable";
    version = "0.14.0";
    hash = "0kjc0ff6b3509s3b9n4q8ilb06d5fngdh3z58cm95vg7zkcas9w3";
    meta.description = "Re2_stable adds an incomplete but stable serialization of Re2";
    propagatedBuildInputs = [ core re2 ];
  };

  record_builder = janePackage {
    pname = "record_builder";
    hash = "004nqcmwll0vy47mb3d3jlk21cc6adcjy62dkv2k966n9jkh472h";
    meta.description = "A library which provides traversal of records with an applicative";
    propagatedBuildInputs = [ base ppx_jane ];
  };

  resource_cache = janePackage {
    pname = "resource_cache";
    hash = "13wzx8ixgbb7jj5yrps890irw2wvkchnihsn7rfrcvnvrjzzjshm";
    meta.description = "General resource cache";
    propagatedBuildInputs = [ async_rpc_kernel ];
  };

  sexp = janePackage {
    pname = "sexp";
    hash = "00xlsymm1mpgs8cqkb6c36vh5hfw0saghvwiqh7jry65qc5nvv9z";
    propagatedBuildInputs = [
      async
      core
      csvfields
      jsonaf
      re2
      sexp_diff
      sexp_macro
      sexp_pretty
      sexp_select
    ];
    meta.description = "S-expression swiss knife";
  };

  sexp_diff = janePackage {
    pname = "sexp_diff";
    hash = "1p5xwhj634ij4a0m5k6a3abddi5315y7is1a6ha1lifdz3v985ll";
    propagatedBuildInputs = [ core_kernel ];
    meta.description = "Code for computing the diff of two sexps";
  };

  sexp_macro = janePackage {
    pname = "sexp_macro";
    hash = "1l5dsv9gawmf5dg3rf8sxphp9qs3n4n038nlmf9rxzypzyn112k8";
    propagatedBuildInputs = [ async sexplib ];
    meta.description = "Sexp macros";
  };

  sexp_pretty = janePackage {
    pname = "sexp_pretty";
    hash = "1p1jspwjvrhm8li22xl0n8wngs12d9g7nc1svk6xc32jralnxblg";
    minimumOCamlVersion = "4.07";
    meta.description = "S-expression pretty-printer";
    propagatedBuildInputs = [ ppx_base re sexplib ];
  };

  sexp_select = janePackage {
    pname = "sexp_select";
    hash = "0mmvga9w3gbb2gd1h4l8f1c3l2lrpn1zld2a8xgqyfqfff3vg31p";
    minimumOCamlVersion = "4.07";
    propagatedBuildInputs = [ base ppx_jane ];
    meta.description = "A library to use CSS-style selectors to traverse sexp trees";
  };

  sexplib0 = janePackage {
    pname = "sexplib0";
    hash = "0jag0bz2173b0n7hx013fhghydhh92arqjlrcnf5x025bw8nz66v";
    minimumOCamlVersion = "4.04.2";
    meta.description = "Library containing the definition of S-expressions and some base converters";
  };

  sexplib = janePackage {
    pname = "sexplib";
    hash = "05h34fm3p0179xivc14bixc50pzc8zws46l5gsq310kpm37srq3c";
    minimumOCamlVersion = "4.04.2";
    meta.description = "Library for serializing OCaml values to and from S-expressions";
    propagatedBuildInputs = [ num parsexp ];
  };

  shell = janePackage {
    pname = "shell";
    hash = "1vzdif7w9y1kw2qynlfixwphdgiflrf43j0fzinjp9f56vlhghhy";
    meta.description = "Yet another implementation of fork&exec and related functionality";
    buildInputs = [ jst-config ];
    propagatedBuildInputs = [ textutils ];
    checkInputs = [ ounit ];
    # This currently fails with dune
    strictDeps = false;
  };

  shexp = janePackage {
    pname = "shexp";
    hash = "05iswnhi92f4yvrh76j3254bvls6fbrdb56mv6vc6mi5f8z4l79i";
    minimumOCamlVersion = "4.07";
    propagatedBuildInputs = [ posixat spawn ];
    meta.description = "Process library and s-expression based shell";
  };

  spawn = janePackage {
    pname = "spawn";
    minimumOCamlVersion = "4.02.3";
    hash = "1fjr91psas5zmk1hxvxh0dchhn0pkyzlr4gg232f5g9vdgissi0p";
    meta.description = "Spawning sub-processes";
    buildInputs = [ ppx_expect ];
  };

  splay_tree = janePackage {
    pname = "splay_tree";
    hash = "1jxfh7f2hjrms5pm2cy1cf6ivphgiqqvyyr9hdcz8d3vi612p4dm";
    meta.description = "A splay tree implementation";
    propagatedBuildInputs = [ core_kernel ];
  };

  splittable_random = janePackage {
    pname = "splittable_random";
    hash = "0ap5z4z1aagz4z02q9642cbl25jzws9lbc2x5xkpyjlc0qcm9v3m";
    meta.description = "PRNG that can be split into independent streams";
    propagatedBuildInputs = [ base ppx_assert ppx_bench ppx_sexp_message ];
  };

  stdio = janePackage {
    pname = "stdio";
    hash = "0g00b00kpjcadikq2asng35w7kvd24q9ldkiylwmn3gv3lrbipa8";
    minimumOCamlVersion = "4.04.2";
    meta.description = "Standard IO library for OCaml";
    propagatedBuildInputs = [ base ];
  };

  textutils = janePackage {
    pname = "textutils";
    hash = "1wass49h645wql9b7nck2iqlkf4648dkxvlvxixr7z80zcnb5rxr";
    meta.description = "Text output utilities";
    propagatedBuildInputs = [ core_unix textutils_kernel ];
  };

  textutils_kernel = janePackage {
    pname = "textutils_kernel";
    hash = "068g11d98wsb5a6ds0p5xybdmx5nx9bxa0k11dmh3l57kn4c169x";
    meta.description = "Text output utilities";
    propagatedBuildInputs = [ core ppx_jane uutf ];
  };

  time_now = janePackage {
    pname = "time_now";
    hash = "1pa0hyh470j9jylii4983qagb6hq2dz6s0q2fnrcph9qbw83bc0c";
    minimumOCamlVersion = "4.04.2";
    meta.description = "Reports the current time";
    buildInputs = [ jst-config ppx_optcomp ];
    propagatedBuildInputs = [ jane-street-headers base ppx_base ];
  };

  timezone = janePackage {
    pname = "timezone";
    hash = "00a007aji5rbz42kgbq1w90py6fm9k9akycs5abkcfll5rd0cbhx";
    meta.description = "Time-zone handling";
    propagatedBuildInputs = [ core_kernel ];
  };

  topological_sort = janePackage {
    pname = "topological_sort";
    hash = "0iqhp8n6g5n1ng80brjpav54229lykm2c1fc104s58lk3rqfvj9v";
    meta.description = "Topological sort algorithm";
    propagatedBuildInputs = [ ppx_jane stdio ];
  };

  typerep = janePackage {
    pname = "typerep";
    hash = "1qxfi01qim0hrgd6d0bgvpxg36i99mmm8cw4wqpr9kxyqvgzv26z";
    minimumOCamlVersion = "4.04.2";
    meta.description = "Typerep is a library for runtime types";
    propagatedBuildInputs = [ base ];
  };

  variantslib = janePackage {
    pname = "variantslib";
    hash = "033ns8ph6bd8g5cdfryjfcnrnzkdshppjyw5kl7cvszjfrz33ij7";
    minimumOCamlVersion = "4.04.2";
    meta.description = "Part of Jane Street's Core library";
    propagatedBuildInputs = [ base ];
  };

  vcaml = janePackage {
    pname = "vcaml";
    hash = "12fd29x9dgf4f14xrx7z4y1bm1wbfynrs3jismjbiqnckfpbqrib";
    meta.description = "OCaml bindings for the Neovim API";
    propagatedBuildInputs = [ angstrom-async async_extra expect_test_helpers_async faraday ];
  };

  virtual_dom = janePackage {
    pname = "virtual_dom";
    hash = "15xia9v4ighzm0gv3vbqk9nvg47cvzqmfnl2zr67yxv4b98kyzv3";
    meta.description = "OCaml bindings for the virtual-dom library";
    buildInputs = [ js_of_ocaml-ppx ];
    propagatedBuildInputs = [ core_kernel gen_js_api js_of_ocaml lambdasoup tyxml ];
  };

  zarith_stubs_js = janePackage {
    pname = "zarith_stubs_js";
    hash = "119xgr3kla9q1bvs4a5z2ivbmsrz4db3a9z0gf77ryqg4i22ywvl";
    minimumOCamlVersion = "4.04.2";
    meta.description = "Javascripts stubs for the Zarith library";
  };

  zstandard = janePackage {
    pname = "zstandard";
    hash = "1blkv35g5q1drkc6zmc4m027gjz6vfdadra1kw1xkp1wlc2l4v3k";
    meta.description = "OCaml bindings to Zstandard";
    buildInputs = [ ppx_jane ];
    propagatedBuildInputs = [ core_kernel ctypes zstd ];
  };

}
