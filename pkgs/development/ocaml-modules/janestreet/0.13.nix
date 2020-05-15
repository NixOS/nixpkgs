{ janePackage
, ctypes
, num
, octavius
, ppxlib
, re
, openssl
}:

rec {

  ocaml-compiler-libs = janePackage {
    pname = "ocaml-compiler-libs";
    version = "0.12.1";
    hash = "0hpk54fcsfcjp536fgwr80mjjf88hjk58q7jwnyrhk2ljd8xzgiv";
    meta.description = "OCaml compiler libraries repackaged";
  };

  sexplib0 = janePackage {
    pname = "sexplib0";
    hash = "1b1bk0xs1hqa12qs5y4h1yl3mq6xml4ya2570dyhdn1j0fbw4g3y";
    meta.description = "Library containing the definition of S-expressions and some base converters";
  };

  base = janePackage {
    pname = "base";
    version = "0.13.1";
    hash = "08a5aymcgr5svvm8v0v20msd5cad64m6maakfbhz4172g7kd9jzw";
    meta.description = "Full standard library replacement for OCaml";
    propagatedBuildInputs = [ sexplib0 ];
  };

  stdio = janePackage {
    pname = "stdio";
    hash = "1hkj9vh8n8p3n5pvx7053xis1pfmqd8p7shjyp1n555xzimfxzgh";
    meta.description = "Standard IO library for OCaml";
    propagatedBuildInputs = [ base ];
  };

  ppx_sexp_conv = janePackage {
    pname = "ppx_sexp_conv";
    hash = "0jkhwmkrfq3ss6bv6i3m871alcr4xpngs6ci6bmzv3yfl7s8bwdf";
    meta.description = "[@@deriving] plugin to generate S-expression conversion functions";
    propagatedBuildInputs = [ ppxlib ];
  };

  ppx_here = janePackage {
    pname = "ppx_here";
    hash = "1ahidrrjsyi0al06bhv5h6aqmdk7ryz8dybfhqjsn1zp9q056q35";
    meta.description = "Expands [%here] into its location";
    propagatedBuildInputs = [ ppxlib ];
  };

  ppx_compare = janePackage {
    pname = "ppx_compare";
    hash = "14pnqa47gsvq93z1b8wb5pyq8zw90aaw71j4pwlyid4s86px454j";
    meta.description = "Generation of comparison functions from types";
    propagatedBuildInputs = [ ppxlib ];
  };

  ppx_cold = janePackage {
    pname = "ppx_cold";
    hash = "0wnfwsgbzk4i5aqjlcaqp6lkvrq5345vazryvx2klbbrd4759h9f";
    meta.description = "Expands [@cold] into [@inline never][@specialise never][@local never]";
    propagatedBuildInputs = [ ppxlib ];
  };

  ppx_assert = janePackage {
    pname = "ppx_assert";
    hash = "08dada2xcp3w5mir90z56qrdyd317lygml4qlfssj897534bwiqr";
    meta.description = "Assert-like extension nodes that raise useful errors on failure";
    propagatedBuildInputs = [ ppx_cold ppx_compare ppx_here ppx_sexp_conv ];
  };

  ppx_inline_test = janePackage {
    pname = "ppx_inline_test";
    hash = "135qzbhqy33lmigbq1rakr9i3y59y3pczh4laanqjyss9b9kfs60";
    meta.description = "Syntax extension for writing in-line tests in ocaml code";
    propagatedBuildInputs = [ ppxlib ];
  };

  ppx_custom_printf = janePackage {
    pname = "ppx_custom_printf";
    hash = "0kvfkdk4wg2z8x705bajvl1f8wiyy3aya203wdzc9425h73nqm5p";
    meta.description = "Printf-style format-strings for user-defined string conversion";
    propagatedBuildInputs = [ ppx_sexp_conv ];
  };

  fieldslib = janePackage {
    pname = "fieldslib";
    hash = "0nsl0i9vjk73pr70ksxqa65rd5v84jzdaazryfdy6i4a5sfg7bxa";
    meta.description = "Syntax extension to define first class values representing record fields, to get and set record fields, iterate and fold over all fields of a record and create new record values";
    propagatedBuildInputs = [ base ];
  };

  ppx_fields_conv = janePackage {
    pname = "ppx_fields_conv";
    hash = "0biw0fgphj522bj9wgjk263i2w92vnpaabzr5zn0grihp4yqy8w4";
    meta.description = "Generation of accessor and iteration functions for ocaml records";
    propagatedBuildInputs = [ fieldslib ppxlib ];
  };

  variantslib = janePackage {
    pname = "variantslib";
    hash = "04nps65v1n0nv9n1c1kj5k9jyqsfsxb6h2w3vf6cibhjr5m7z8xc";
    meta.description = "Part of Jane Street's Core library";
    propagatedBuildInputs = [ base ];
  };

  ppx_variants_conv = janePackage {
    pname = "ppx_variants_conv";
    hash = "1ssinizz11bws06qzjky486cj1zrflij1f7hi16d02j40qmyjz7b";
    meta.description = "Generation of accessor and iteration functions for ocaml variant types";
    propagatedBuildInputs = [ variantslib ppxlib ];
  };

  ppx_expect = janePackage {
    pname = "ppx_expect";
    hash = "1hhcga960wjvhcx5pk7rcywl1p9n2ycvqa294n24m8dhzqia6i47";
    meta.description = "Cram like framework for OCaml";
    propagatedBuildInputs = [ ppx_assert ppx_custom_printf ppx_fields_conv ppx_inline_test ppx_variants_conv re ];
  };

  ppx_enumerate = janePackage {
    pname = "ppx_enumerate";
    hash = "0hsg6f2nra1mb35jdgym5rf7spm642bs6qqifbikm9hg8f7z3ql4";
    meta.description = "Generate a list containing all values of a finite type";
    propagatedBuildInputs = [ ppxlib ];
  };

  ppx_hash = janePackage {
    pname = "ppx_hash";
    hash = "1f7mfyx4wgk67hchi57w3142m61ka3vgy1969cbkwr3akv6ifly2";
    meta.description = "A ppx rewriter that generates hash functions from type expressions and definitions";
    propagatedBuildInputs = [ ppx_compare ppx_sexp_conv ];
  };

  ppx_js_style = janePackage {
    pname = "ppx_js_style";
    hash = "1zlhcn0an5k9xjymk5z5m2vqi8zajy6nvcbl5sdn19pjl3zv645x";
    meta.description = "Code style checker for Jane Street Packages";
    propagatedBuildInputs = [ octavius ppxlib ];
  };

  ppx_base = janePackage {
    pname = "ppx_base";
    hash = "0dkqc85x7bgbb6lgx9rghvj1q4dpdgy9qgjl88ywi4c8l9rgnnkz";
    meta.description = "Base set of ppx rewriters";
    propagatedBuildInputs = [ ppx_cold ppx_enumerate ppx_hash ppx_js_style ];
  };

  ppx_bench = janePackage {
    pname = "ppx_bench";
    hash = "0snmy05d3jgihmppixx3dzamkykijqa2v43vpd7q4z8dpnip620g";
    meta.description = "Syntax extension for writing in-line benchmarks in ocaml code";
    propagatedBuildInputs = [ ppx_inline_test ];
  };

  ppx_sexp_message = janePackage {
    pname = "ppx_sexp_message";
    hash = "03jhx3ajcv22iwxkg1jf1jjvd14gyrwi1yc6c5ryqi5ha0fywfw6";
    meta.description = "A ppx rewriter for easy construction of s-expressions";
    propagatedBuildInputs = [ ppx_here ppx_sexp_conv ];
  };

  splittable_random = janePackage {
    pname = "splittable_random";
    hash = "1kgcd6k31vsd7638g8ip77bp1b7vzgkbvgvij4jm2igl09132r85";
    meta.description = "PRNG that can be split into independent streams";
    propagatedBuildInputs = [ base ppx_assert ppx_bench ppx_sexp_message ];
  };

  ppx_let = janePackage {
    pname = "ppx_let";
    hash = "0qplsvbv10h7kwf6dhhgvi001gfphv1v66s83zjr5zbypyaarg5y";
    meta.description = "Monadic let-bindings";
    propagatedBuildInputs = [ ppxlib ];
  };

  base_quickcheck = janePackage {
    pname = "base_quickcheck";
    hash = "0ik8llm01m2xap4gia0vpsh7yq311hph7a2kf5109ag4988s8p0w";
    meta.description = "Randomized testing framework, designed for compatibility with Base";
    propagatedBuildInputs = [ ppx_base ppx_fields_conv ppx_let splittable_random ];
  };

  ppx_stable = janePackage {
    pname = "ppx_stable";
    hash = "0h7ls1bs0bsd8c4na4aj0nawwhvfy50ybm7sza7yz3qli9jammjk";
    meta.description = "Stable types conversions generator";
    propagatedBuildInputs = [ ppxlib ];
  };

  bin_prot = janePackage {
    pname = "bin_prot";
    hash = "1nnr21rljlfglmhiji27d7c1d6gg5fk4cc5rl3750m98w28mfdjw";
    meta.description = "A binary protocol generator";
    propagatedBuildInputs = [ ppx_compare ppx_custom_printf ppx_fields_conv ppx_variants_conv ];
  };

  ppx_bin_prot = janePackage {
    pname = "ppx_bin_prot";
    hash = "14nfjgqisdqqg8wg4qzvc859zil82y0qpr8fm4nhq05mgxp37iyc";
    meta.description = "Generation of bin_prot readers and writers from types";
    propagatedBuildInputs = [ bin_prot ppx_here ];
  };

  ppx_fail = janePackage {
    pname = "ppx_fail";
    hash = "165mikjg4a1lahq3n9q9y2h36jbln5g3l2hapx17irvf0l0c3vn5";
    meta.description = "Add location to calls to failwiths";
    propagatedBuildInputs = [ ppx_here ];
  };

  jst-config = janePackage {
    pname = "jst-config";
    hash = "15lj6f83hz555xhjy9aayl3adqwgl1blcjnja693a1ybi3ca8w0y";
    meta.description = "Compile-time configuration for Jane Street libraries";
    buildInputs = [ ppx_assert ];
  };

  ppx_optcomp = janePackage {
    pname = "ppx_optcomp";
    hash = "13db395swqf7v87pgl9qiyj4igmvj57hpl8blx3kkrzj6ddh38a8";
    meta.description = "Optional compilation for OCaml";
    propagatedBuildInputs = [ ppxlib ];
  };

  jane-street-headers = janePackage {
    pname = "jane-street-headers";
    hash = "1qjg2ari0xn40dlbk0h9xkwr37k97ldkxpkv792fbl6wc2jlv3x5";
    meta.description = "Jane Street C header files";
  };

  time_now = janePackage {
    pname = "time_now";
    hash = "1if234kz1ssmv22c0vh1cwhbivab6yy3xvy37ny1q4k5ibjc3v0n";
    meta.description = "Reports the current time";
    buildInputs = [ jst-config ppx_optcomp ];
    propagatedBuildInputs = [ jane-street-headers base ppx_base ];
  };

  ppx_module_timer = janePackage {
    pname = "ppx_module_timer";
    hash = "13kv5fzwf41wsaksj41hnvcpx8pnbmzcainlq6f5shj9671hpnhb";
    meta.description = "Ppx rewriter that records top-level module startup times";
    propagatedBuildInputs = [ time_now ];
  };

  ppx_optional = janePackage {
    pname = "ppx_optional";
    hash = "1nwb9jvmszxddj9wxgv9g02qhr10yymm2q1w1gjfqd97m2m1mx4n";
    meta.description = "Pattern matching on flat options";
    propagatedBuildInputs = [ ppxlib ];
  };

  ppx_pipebang = janePackage {
    pname = "ppx_pipebang";
    hash = "0ybj0flsi95pf13ayzz1lcrqhqvkv1lm2dz6y8w49f12583496mc";
    meta.description = "A ppx rewriter that inlines reverse application operators `|>` and `|!`";
    propagatedBuildInputs = [ ppxlib ];
  };

  ppx_sexp_value = janePackage {
    pname = "ppx_sexp_value";
    hash = "18k5015awv9yjl44cvdmp3pn894cgsxmn5s7picxapm9675xqcg9";
    meta.description = "A ppx rewriter that simplifies building s-expressions from ocaml values";
    propagatedBuildInputs = [ ppx_here ppx_sexp_conv ];
  };

  typerep = janePackage {
    pname = "typerep";
    hash = "116hlifww2cqq1i9vwpl7ziwkc1na7p9icqi9srpdxnvn8ibcsas";
    meta.description = "Typerep is a library for runtime types";
    propagatedBuildInputs = [ base ];
  };

  ppx_typerep_conv = janePackage {
    pname = "ppx_typerep_conv";
    hash = "1jlmga9i79inr412l19n4vvmgafzp1bznqxwhy42x309wblbhxx9";
    meta.description = "Generation of runtime types from type declarations";
    propagatedBuildInputs = [ ppxlib typerep ];
  };

  ppx_jane = janePackage {
    pname = "ppx_jane";
    hash = "1a86rvnry8lvjhsg2k73f5bgz7l2962k5i49yzmzn8w66kj0yz60";
    meta.description = "Standard Jane Street ppx rewriters";
    propagatedBuildInputs = [ base_quickcheck ppx_bench ppx_bin_prot ppx_expect ppx_fail ppx_module_timer ppx_optcomp ppx_optional ppx_pipebang ppx_sexp_value ppx_stable ppx_typerep_conv ];
  };

  base_bigstring = janePackage {
    pname = "base_bigstring";
    hash = "1i3zr8bn71l442vl5rrvjpwphx20frp2vaw1qc05d348j76sxfp7";
    meta.description = "String type based on [Bigarray], for use in I/O and C-bindings";
    propagatedBuildInputs = [ ppx_jane ];
  };

  parsexp = janePackage {
    pname = "parsexp";
    hash = "0fsxy5lpsvfadj8m2337j8iprs294dfikqxjcas7si74nskx6l38";
    meta.description = "S-expression parsing library";
    propagatedBuildInputs = [ base sexplib0 ];
  };

  sexplib = janePackage {
    pname = "sexplib";
    hash = "059ypcyirw00x6dqa33x49930pwxcr3i72qz5pf220js2ai2nzhn";
    meta.description = "Library for serializing OCaml values to and from S-expressions";
    propagatedBuildInputs = [ num parsexp ];
  };

  core_kernel = janePackage {
    version = "0.13.1";
    pname = "core_kernel";
    hash = "1ynyz6jkf23q0cwbn6kv06mgyjd644qxb0qkrydq0cglcaa4kjhp";
    meta.description = "System-independent part of Core";
    buildInputs = [ jst-config ];
    propagatedBuildInputs = [ base_bigstring sexplib ];
  };

  spawn = janePackage {
    pname = "spawn";
    hash = "1w003k1kw1lmyiqlk58gkxx8rac7dchiqlz6ah7aj7bh49b36ppf";
    meta.description = "Spawning sub-processes";
    buildInputs = [ ppx_expect ];
  };

  core = janePackage {
    pname = "core";
    hash = "1i5z9myl6i7axd8dz4b71gdsz9la6k07ib9njr4bn12yn0y76b1m";
    meta.description = "System-independent part of Core";
    buildInputs = [ jst-config ];
    propagatedBuildInputs = [ core_kernel spawn ];
  };

  async_kernel = janePackage {
    pname = "async_kernel";
    hash = "1rrbyy3pyh31qwv0jiarhpgdyq2z2gx6axmaplgpxshk4qx6gsld";
    meta.description = "Monadic concurrency library";
    propagatedBuildInputs = [ core_kernel ];
  };

  protocol_version_header = janePackage {
    pname = "protocol_version_header";
    hash = "19wscd81jlj355f9din1sg21m3af456a0id2a37bx38r390wrghc";
    meta.description = "Protocol versioning";
    propagatedBuildInputs = [ core_kernel ];
  };

  async_rpc_kernel = janePackage {
    pname = "async_rpc_kernel";
    hash = "1k3f2psyd1xcf7nkk0q1fq57yyhfqbzyynsz821n7mrnm37simac";
    meta.description = "Platform-independent core of Async RPC library";
    propagatedBuildInputs = [ async_kernel protocol_version_header ];
  };

  async_unix = janePackage {
    pname = "async_unix";
    hash = "0n3jz3qjlphyhkqgnbjbwf2fqxaksws82dx1mk4m4wnw3275gdi5";
    meta.description = "Monadic concurrency library";
    propagatedBuildInputs = [ async_kernel core ];
  };

  async_extra = janePackage {
    pname = "async_extra";
    hash = "06q1farx7dwi4h490xi1azq7ym57ih2d23sq17g2jfvw889kf4n1";
    meta.description = "Monadic concurrency library";
    propagatedBuildInputs = [ async_rpc_kernel async_unix ];
  };

  textutils = janePackage {
    pname = "textutils";
    hash = "1wnyqj9dzfgl0kddmdl4n9rkl16hwy432dd2i4ksvk2z5g9kkb0d";
    meta.description = "Text output utilities";
    propagatedBuildInputs = [ core ];
  };

  async = janePackage {
    pname = "async";
    hash = "002j9yxpw0ghi12a84163vaqa3n9h8j35f4i72nbxnilxwvy95sr";
    meta.description = "Monadic concurrency library";
    propagatedBuildInputs = [ async_rpc_kernel async_unix textutils ];
  };

  async_find = janePackage {
    pname = "async_find";
    hash = "0l8cfhyrx2rb2avdcfx5m70aj6rx2d57qxqvfycad5afqz4xx2n9";
    meta.description = "Directory traversal with Async";
    propagatedBuildInputs = [ async ];
  };

  re2 = janePackage {
    pname = "re2";
    hash = "0hmizznlzilynn5kh6149bbpkfw2l0xi7zi1y1fxfww2ma3wpim0";
    meta.description = "OCaml bindings for RE2, Google's regular expression library";
    propagatedBuildInputs = [ core_kernel ];
    prePatch = ''
      substituteInPlace src/re2_c/dune --replace 'CXX=g++' 'CXX=c++'
      substituteInPlace src/dune --replace '(cxx_flags (:standard \ -pedantic) (-I re2_c/libre2))' '(cxx_flags (:standard \ -pedantic) (-I re2_c/libre2) (-x c++))'
    '';
  };

  shell = janePackage {
    pname = "shell";
    hash = "190ymhm0z9b7hngbcpg88wwrfxwfcdh339d7rd2xhmrhi4z99r18";
    meta.description = "Yet another implementation of fork&exec and related functionality";
    buildInputs = [ jst-config ];
    propagatedBuildInputs = [ re2 textutils ];
  };

  async_shell = janePackage {
    pname = "async_shell";
    hash = "0bfxyvdmyv23zfr49pb4c3bgfkjr4s3nb3z07xrw6szia3j1kp4j";
    meta.description = "Shell helpers for Async";
    propagatedBuildInputs = [ async shell ];
  };

  core_bench = janePackage {
    pname = "core_bench";
    hash = "1nk0i3z8rqrljbf4bc7ljp71g0a4361nh85s2ang0lgxri74zacm";
    meta.description = "Benchmarking library";
    propagatedBuildInputs = [ textutils ];
  };

  core_extended = janePackage {
    pname = "core_extended";
    hash = "0zh1wwkg5cxkz633dl9zbbl65aksvzb5mss1q8f7w6i1sv3n0135";
    meta.description = "Extra components that are not as closely vetted or as stable as Core";
    propagatedBuildInputs = [ core ];
  };

  sexp_pretty = janePackage {
    pname = "sexp_pretty";
    hash = "1a59xc9frmvi7n0i32dzs8gpf5ral80xkwv97a13zv5cyg8l6216";
    meta.description = "S-expression pretty-printer";
    propagatedBuildInputs = [ ppx_base re sexplib ];
  };

  expect_test_helpers_kernel = janePackage {
    pname = "expect_test_helpers_kernel";
    hash = "11m0i7mj6b1cmqnwhmsrqdc814s0lk3sip8rh97k75grngazmjvn";
    meta.description = "Helpers for writing expectation tests";
    buildInputs = [ ppx_jane ];
    propagatedBuildInputs = [ core_kernel sexp_pretty ];
  };

  expect_test_helpers = janePackage {
    pname = "expect_test_helpers";
    hash = "0sw9yam8d9hdam8p194q0hgc4i26vvwj5qi2cba1jxfhdzhy8jdd";
    meta.description = "Async helpers for writing expectation tests";
    propagatedBuildInputs = [ async expect_test_helpers_kernel ];
  };

  patience_diff = janePackage {
    pname = "patience_diff";
    hash = "012rlbnw21yq2lsbfk3f7l4m4qq3jdx238146z36v54vnhhs6r2r";
    meta.description = "Diff library using Bram Cohen's patience diff algorithm";
    propagatedBuildInputs = [ core_kernel ];
  };

  ecaml = janePackage {
    pname = "ecaml";
    hash = "0jmmsi1m7d4cl5mnw6v9h4ng29anwxy73a6qfi28lgpzafn452bc";
    meta.description = "Library for writing Emacs plugin in OCaml";
    propagatedBuildInputs = [ async expect_test_helpers_kernel ];
  };

  ### Packages at version 0.11, with dependencies at version 0.12

  configurator = janePackage {
    pname = "configurator";
    version = "0.11.0";
    hash = "0h686630cscav7pil8c3w0gbh6rj4b41dvbnwmicmlkc746q5bfk";
    propagatedBuildInputs = [ stdio ];
    meta.description = "Helper library for gathering system configuration";
  };

  ppx_core = janePackage {
    pname = "ppx_core";
    version = "0.11.0";
    hash = "11hgm9mxig4cm3c827f6dns9mjv3pf8g6skf10x0gw9xnp1dmzmx";
    propagatedBuildInputs = [ ppxlib ];
    meta.description = "Deprecated (see ppxlib)";
  };

  ppx_driver = janePackage {
    pname = "ppx_driver";
    version = "0.11.0";
    hash = "00kfx6js2kxk57k4v7hiqvwk7h35whgjihnxf75m82rnaf4yzvfi";
    propagatedBuildInputs = [ ppxlib ];
    meta.description = "Deprecated (see ppxlib)";
  };

  ppx_type_conv = janePackage {
    pname = "ppx_type_conv";
    version = "0.11.0";
    hash = "04dbrglqqhkas25cpjz8xhjcbpk141c35qggzw66bn69izczfmaf";
    propagatedBuildInputs = [ ppxlib ];
    meta.description = "Deprecated (see ppxlib)";
  };

}
