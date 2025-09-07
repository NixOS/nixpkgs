{
  self,
  bash,
  fetchpatch,
  fzf,
  lib,
  openssl,
  zstd,
  krb5,
}:

let
  js_of_ocaml-compiler = self.js_of_ocaml-compiler.override { version = "5.9.1"; };
  js_of_ocaml = self.js_of_ocaml.override { inherit js_of_ocaml-compiler; };
  gen_js_api = self.gen_js_api.override {
    inherit js_of_ocaml-compiler;
    ojs = self.ojs.override { inherit js_of_ocaml-compiler; };
  };
  js_of_ocaml-ppx = self.js_of_ocaml-ppx.override { inherit js_of_ocaml; };
in

with self;

{

  abstract_algebra = janePackage {
    pname = "abstract_algebra";
    hash = "sha256-hAZzc2ypbGE/8mxxk4GZqr17JlIYv71gZJMQ4plsK38=";
    meta.description = "Small library describing abstract algebra concepts";
    propagatedBuildInputs = [
      base
      ppx_jane
    ];
  };

  accessor = janePackage {
    pname = "accessor";
    hash = "sha256-yClfUXqwVoipF4WqbqC6VBVYc6t8MZYVoHGjchH7XQA=";
    meta.description = "Library that makes it nicer to work with nested functional data structures";
    propagatedBuildInputs = [ higher_kinded ];
  };

  accessor_async = janePackage {
    pname = "accessor_async";
    hash = "sha256-kGT7aFNOgU8/2ez9L/lefb2LN7I87+WthZHnb+dY9PE=";
    meta.description = "Accessors for Async types, for use with the Accessor library";
    propagatedBuildInputs = [
      accessor_core
      async_kernel
    ];
  };

  accessor_base = janePackage {
    pname = "accessor_base";
    hash = "sha256-idnSNP6kfoV3I8QAMJ2YoUrewBpyte+0/C371aMTIxo=";
    meta.description = "Accessors for Base types, for use with the Accessor library";
    propagatedBuildInputs = [ ppx_accessor ];
  };

  accessor_core = janePackage {
    pname = "accessor_core";
    hash = "sha256-f4s/I+xDi/aca1WgaE+P3CD4e80jenS0WHg4T1Stcbg=";
    meta.description = "Accessors for Core types, for use with the Accessor library";
    propagatedBuildInputs = [
      accessor_base
      core_kernel
    ];
  };

  async = janePackage {
    pname = "async";
    hash = "sha256-TpsC9sn8noiNI0aYbMalUUv3xlC2LMERsv6Gr928Vzc=";
    meta.description = "Monadic concurrency library";
    propagatedBuildInputs = [
      async_rpc_kernel
      async_unix
      textutils
    ];
    doCheck = false; # we don't have netkit_sockets
  };

  async_durable = janePackage {
    pname = "async_durable";
    hash = "sha256-PImYpM9xNFUWeWRld4jFwWBRowUP1iXzdxkK/fP/rHE=";
    meta.description = "Durable connections for use with async";
    propagatedBuildInputs = [
      async_kernel
      async_rpc_kernel
      core
      core_kernel
      ppx_jane
    ];
  };

  async_extra = janePackage {
    pname = "async_extra";
    hash = "sha256-Y+gTlJuKmwvEEPuMPu7v0iYeNQtlzP8QiS0PSgoYrrI=";
    meta.description = "Monadic concurrency library";
    propagatedBuildInputs = [ async_kernel ];
  };

  async_find = janePackage {
    pname = "async_find";
    hash = "sha256-PG6BJx9tfP+zcDaG+7WdHiv4jUqsUH2TvHV6UXdzPAg=";
    meta.description = "Directory traversal with Async";
    propagatedBuildInputs = [ async ];
  };

  async_inotify = janePackage {
    pname = "async_inotify";
    hash = "sha256-seFbs06w3T+B49sw3nOjpXpoJbJ+IJ3qN5LnufrsE48=";
    meta.description = "Async wrapper for inotify";
    propagatedBuildInputs = [
      async_find
      inotify
    ];
  };

  async_interactive = janePackage {
    pname = "async_interactive";
    hash = "sha256-xZKVT8L2rOLBeg7wK0tD6twhkDfwQp5ZKy4DPp1UWq8=";
    meta.description = "Utilities for building simple command-line based user interfaces";
    propagatedBuildInputs = [ async ];
  };

  async_js = janePackage {
    pname = "async_js";
    hash = "sha256-JyF1busOv9JWxp55oaxBozIQyCKlmAY3csBA4/98qy0=";
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
    hash = "sha256-EDgdZc6GRyiiFtnElNE9jGPEjPIUniP9uB/JoySkZz8=";
    meta.description = "Monadic concurrency library";
    propagatedBuildInputs = [ core_kernel ];
  };

  async_rpc_kernel = janePackage {
    pname = "async_rpc_kernel";
    hash = "sha256-OccFMfhTRSQwx1LJcN8OkDpA62KabsyWn2hox84jqow=";
    meta.description = "Platform-independent core of Async RPC library";
    propagatedBuildInputs = [
      async_kernel
      protocol_version_header
    ];
  };

  async_rpc_websocket = janePackage {
    pname = "async_rpc_websocket";
    hash = "sha256-S3xIw/mew9YhtenWfp8ZD82WtOQSzJHtreT1+kRivus=";
    meta.description = "Library to serve and dispatch Async RPCs over websockets";
    propagatedBuildInputs = [
      async_rpc_kernel
      async_websocket
      cohttp_async_websocket
    ];
  };

  async_sendfile = janePackage {
    pname = "async_sendfile";
    hash = "sha256-ykl87/De56gz6JRQfTIeWrU823PT2fnFJr08GxuDYic=";
    meta.description = "Thin wrapper around [Linux_ext.sendfile] to send full files";
    propagatedBuildInputs = [ async_unix ];
  };

  async_shell = janePackage {
    pname = "async_shell";
    hash = "sha256-DjIbadCjPymnkDsnonmxKumCWf5P9XO3ZaAwOaYRnbk=";
    meta.description = "Shell helpers for Async";
    propagatedBuildInputs = [
      async
      shell
    ];
  };

  async_smtp = janePackage {
    pname = "async_smtp";
    hash = "sha256-X0eegZMMU9EnC9Oi+6DjtwNmyzQYr3EKi1duNzEAfkk=";
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
    version = "0.16.1";
    pname = "async_ssl";
    hash = "sha256-83YKxvVb/JwBnQG4R/R1Ztik9T/hO4cbiNTfFnErpG4=";
    patches = fetchpatch {
      url = "https://raw.githubusercontent.com/ocaml/opam-source-archives/d7f046579bfc7cfe77ce12f57fd11c206e7e9f30/patches/async_ssl/no-incompatible-pointer-types-0161.patch";
      hash = "sha256-NcQX9eZ97kaQCOVAuYgR8NlFD3ZrGbT/2QqCjYf9Xnw=";
    };
    meta.description = "Async wrappers for SSL";
    buildInputs = [ dune-configurator ];
    propagatedBuildInputs = [
      async
      ctypes
      ctypes-foreign
      openssl
    ];
  };

  async_unix = janePackage {
    pname = "async_unix";
    hash = "sha256-dT+yJC73sxS4NPR/GC/FyVLbWtYpM9DqKykVk8PEEWU=";
    meta.description = "Monadic concurrency library";
    propagatedBuildInputs = [
      async_kernel
      core_unix
    ];
  };

  async_websocket = janePackage {
    pname = "async_websocket";
    hash = "sha256-Qy+A8ee6u5Vr05FNeaH/6Sdp9bcq3cnaDYO9OU06VW0=";
    meta.description = "Library that implements the websocket protocol on top of Async";
    propagatedBuildInputs = [
      async
      cryptokit
    ];
  };

  babel = janePackage {
    pname = "babel";
    hash = "sha256-nnMliU0d6vtHTYEy9uMi8nMaHvAsEXKN6uNByqZ28+c=";
    meta.description = "Library for defining Rpcs that can evolve over time without breaking backward compatibility";
    propagatedBuildInputs = [
      async_rpc_kernel
      core
      ppx_jane
      streamable
      tilde_f
    ];
  };

  base = janePackage {
    pname = "base";
    version = "0.16.2";
    hash = "sha256-8OvZe+aiWipJ6busBufx3OqERmqxBva55UOLjL8KoPc=";
    meta.description = "Full standard library replacement for OCaml";
    buildInputs = [ dune-configurator ];
    propagatedBuildInputs = [ sexplib0 ];
    checkInputs = [ alcotest ];
  };

  base_bigstring = janePackage {
    pname = "base_bigstring";
    hash = "sha256-gQbzdr05DEowzd0k9JBTF0gGMwlaVwTVJuoKZ0u9voU=";
    meta.description = "String type based on [Bigarray], for use in I/O and C-bindings";
    propagatedBuildInputs = [
      int_repr
      ppx_jane
    ];
  };

  base_trie = janePackage {
    pname = "base_trie";
    hash = "sha256-KV/k3B0h/4rE+MY6f4qDnlaObMmewUS+NAN2M7sb+yw=";
    meta.description = "Trie data structure library";
    propagatedBuildInputs = [
      base
      core
      expect_test_helpers_core
      ppx_jane
    ];
  };

  base_quickcheck = janePackage {
    pname = "base_quickcheck";
    hash = "sha256-9Flg8vAoT6f+3lw9wETQhsaA1fSsQiqKeEhzo0qtDu4=";
    meta.description = "Randomized testing framework, designed for compatibility with Base";
    propagatedBuildInputs = [
      ppx_base
      ppx_fields_conv
      ppx_let
      ppx_sexp_value
      splittable_random
    ];
  };

  bidirectional_map = janePackage {
    pname = "bidirectional_map";
    hash = "sha256-YEzOdzanBJaskI2/xN9E3ozWnBXDyxJvY3g/qEE73yI=";
    meta.description = "Library for bidirectional maps and multimaps";
  };

  bignum = janePackage {
    pname = "bignum";
    hash = "sha256-PmvqGImF1Nrr6swx5q3+9mCfSbieC3RvWuz8oCTkSgg=";
    propagatedBuildInputs = [
      core_kernel
      zarith
      zarith_stubs_js
    ];
    meta.description = "Core-flavoured wrapper around zarith's arbitrary-precision rationals";
  };

  bin_prot = janePackage {
    pname = "bin_prot";
    hash = "sha256-qFkM6TrTLnnFKmzQHktBb68HpBTMYhiURvnRKEoAevk=";
    meta.description = "Binary protocol generator";
    propagatedBuildInputs = [
      ppx_compare
      ppx_custom_printf
      ppx_fields_conv
      ppx_optcomp
      ppx_stable_witness
      ppx_variants_conv
    ];
  };

  bonsai = janePackage {
    pname = "bonsai";
    hash = "sha256-YJ+qkVG5PLBmioa1gP7y6jwn82smyyYDIwHwhDqNeWM=";
    meta.description = "Library for building dynamic webapps, using Js_of_ocaml";
    buildInputs = [ ppx_pattern_bind ];
    nativeBuildInputs = [
      ppx_css
      js_of_ocaml-compiler
      ocaml-embed-file
    ];
    propagatedBuildInputs = [
      async
      async_durable
      async_extra
      async_rpc_websocket
      babel
      cohttp-async
      core_bench
      fuzzy_match
      incr_dom
      indentation_buffer
      js_of_ocaml-ppx
      ordinal_abbreviation
      patdiff
      polling_state_rpc
      ppx_css
      ppx_typed_fields
      profunctor
      sexp_grammar
      textutils
    ];
  };

  cinaps = janePackage {
    pname = "cinaps";
    version = "0.15.1";
    hash = "sha256-LycruanldSP251uYJjQqIfI76W0UQ6o5i5u8XjszBT0=";
    meta.description = "Trivial metaprogramming tool";
    minimalOCamlVersion = "4.04";
    propagatedBuildInputs = [ re ];
    doCheck = false; # fails because ppx_base doesn't include ppx_js_style
  };

  cohttp_async_websocket = janePackage {
    pname = "cohttp_async_websocket";
    hash = "sha256-OBtyKMyvfz0KNG4SWmvoTMVPnVTpO12N38q+kEbegJE=";
    meta.description = "Websocket library for use with cohttp and async";
    propagatedBuildInputs = [
      async_ssl
      async_websocket
      cohttp-async
      ppx_jane
      uri-sexp
    ];
  };

  cohttp_static_handler = janePackage {
    pname = "cohttp_static_handler";
    hash = "sha256-7NCnJVArudBEvWARQUGlJuEq3kSCjpn5YtsLsL04bf4=";
    meta.description = "Library for easily creating a cohttp handler for static files";
    propagatedBuildInputs = [ cohttp-async ];
  };

  content_security_policy = janePackage {
    pname = "content_security_policy";
    hash = "sha256-q/J+ZzeC6txyuRQzR8Hmu7cYJCQbxaMlVEmK8fj0hus=";
    meta.description = "Library for building content-security policies";
    propagatedBuildInputs = [
      core
      ppx_jane
    ];
  };

  core = janePackage {
    pname = "core";
    version = "0.16.2";
    hash = "sha256-cyOU++XJJkU2YMHfn8saFOxLoQSFhF7kARJi/9unbFQ=";
    meta.description = "Industrial strength alternative to OCaml's standard library";
    buildInputs = [ jst-config ];
    propagatedBuildInputs = [
      base
      base_bigstring
      base_quickcheck
      ppx_jane
      time_now
    ];
    doCheck = false; # circular dependency with core_kernel
  };

  core_bench = janePackage {
    pname = "core_bench";
    hash = "sha256-ASdu3ZUk+nkdNX9UbBQxKRdXBa073mWMDRW+Ceu3/t4=";
    meta.description = "Benchmarking library";
    propagatedBuildInputs = [ textutils ];
  };

  core_extended = janePackage {
    pname = "core_extended";
    hash = "sha256-hcjmFDdVKCHK8u6D4Qn2a/HYTEZOvkXHcB6BTpbjF/s=";
    meta.description = "Extra components that are not as closely vetted or as stable as Core";
    propagatedBuildInputs = [
      core_unix
      record_builder
    ];
  };

  core_kernel = janePackage {
    pname = "core_kernel";
    hash = "sha256-YB3WMNLePrOKu+mmVedNo0pWN9x5fIaBxJsby56TFJU=";
    meta.description = "System-independent part of Core";
    buildInputs = [ jst-config ];
    propagatedBuildInputs = [
      base_bigstring
      core
      int_repr
      sexplib
    ];
    doCheck = false; # we don't have quickcheck_deprecated
  };

  core_unix = janePackage {
    pname = "core_unix";
    hash = "sha256-mePpxjbUumMemHDKhRgACilchgS6QHZEV1ghYtT3flg=";
    meta.description = "Unix-specific portions of Core";
    buildInputs = [ jst-config ];
    propagatedBuildInputs = [
      core_kernel
      expect_test_helpers_core
      ocaml_intrinsics
      ppx_jane
      timezone
      spawn
    ];
    postPatch = ''
      patchShebangs unix_pseudo_terminal/src/discover.sh
    '';
  };

  csvfields = janePackage {
    pname = "csvfields";
    hash = "sha256-FEkjRmLeqNvauBlrY2xtLZfxVfnFWU8w8noEArPUieo=";
    propagatedBuildInputs = [
      core
      num
    ];
    meta.description = "Runtime support for ppx_xml_conv and ppx_csv_conv";
  };

  dedent = janePackage {
    pname = "dedent";
    hash = "sha256-fzytLr3tVr2vPmykUBzNFMxnyMcIeeo8S9BydsTKnQw=";
    propagatedBuildInputs = [
      base
      ppx_jane
      stdio
    ];
    meta.description = "Library for improving readability of multi-line string constants in code";
  };

  delimited_parsing = janePackage {
    pname = "delimited_parsing";
    hash = "sha256-XyO3hzPz48i1cnMTJvZfarM6HC7qdHqdftp9SnCjPEU=";
    propagatedBuildInputs = [
      async
      core_extended
    ];
    meta.description = "Parsing of character (e.g., comma) separated and fixed-width values";
  };

  diffable = janePackage {
    pname = "diffable";
    hash = "sha256-ascQUbxzvRR8XrroaupyFZ2YNQMvlXn4PemumYTwRF4=";
    propagatedBuildInputs = [
      core
      ppx_jane
      stored_reversed
      streamable
    ];
    meta.description = "Interface for diffs";
  };

  ecaml = janePackage {
    pname = "ecaml";
    hash = "sha256-VS7eTTD85ci3mJIXd2pG1Y/ygT9dCIvfzU2HtOufW6U=";
    meta.description = "Library for writing Emacs plugin in OCaml";
    propagatedBuildInputs = [
      async
      expect_test_helpers_core
    ];
  };

  email_message = janePackage {
    pname = "email_message";
    hash = "sha256-eso68owbAspjaVgj/wGFQ7VQYlAwyYV3oNitLQWiRPA=";
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

  env_config = janePackage {
    pname = "env_config";
    hash = "sha256-CvvpKI7F40DVC7iByrzCqW1ilPiIhdDPYaJrDoUZVSs=";
    meta.description = "Helper library for retrieving configuration from an environment variable";
    propagatedBuildInputs = [
      async
      core
      core_unix
      ppx_jane
    ];
  };

  expect_test_helpers_async = janePackage {
    pname = "expect_test_helpers_async";
    hash = "sha256-dEvOMb1aCEt05XtkKIC9jWoIQ/2zM0Gj+K/ZN3bFjeI=";
    meta.description = "Async helpers for writing expectation tests";
    propagatedBuildInputs = [
      async
      expect_test_helpers_core
    ];
  };

  expect_test_helpers_core = janePackage {
    pname = "expect_test_helpers_core";
    hash = "sha256-8DsMwk9WhQQ7iMNYSFBglfbcgvE5dySt4J4qjzJ3dJk=";
    meta.description = "Helpers for writing expectation tests";
    propagatedBuildInputs = [
      core_kernel
      sexp_pretty
    ];
  };

  fieldslib = janePackage {
    pname = "fieldslib";
    hash = "sha256-dwkO65sBsPfTF0F2FKrnttEjhAY2OMbJetSgOfUXk3A=";
    meta.description = "Syntax extension to define first class values representing record fields, to get and set record fields, iterate and fold over all fields of a record and create new record values";
    propagatedBuildInputs = [ base ];
  };

  file_path = janePackage {
    pname = "file_path";
    hash = "sha256-EEpDZNgUgyeqivRhZgQWWlerl+7OOcvAbjjQ3e1NYOQ=";
    meta.description = "Library for typed manipulation of UNIX-style file paths";
    propagatedBuildInputs = [
      async
      core
      core_kernel
      core_unix
      expect_test_helpers_async
      expect_test_helpers_core
      ppx_jane
    ];
  };

  fuzzy_match = janePackage {
    pname = "fuzzy_match";
    hash = "sha256-M3yOqP0/OZFbqZZpgDdhJ/FZU3MhKwIXbWjwuMlxe2Q=";
    meta.description = "Library for fuzzy string matching";
    propagatedBuildInputs = [
      core
      ppx_jane
    ];
  };

  fzf = janePackage {
    pname = "fzf";
    hash = "sha256-IQ2wze34LlOutecDOrPhj3U7MFVJTSjQW+If3QyHoes=";
    meta.description = "Library for running the fzf command line tool";
    propagatedBuildInputs = [
      async
      core_kernel
      ppx_jane
    ];
    postPatch = ''
      substituteInPlace src/fzf.ml --replace /usr/bin/fzf ${fzf}/bin/fzf
    '';
  };

  hex_encode = janePackage {
    pname = "hex_encode";
    hash = "sha256-jnsf5T1D1++AUdrato/NO3gTVXu14klXozHFIG9HH/o=";
    meta.description = "Hexadecimal encoding library";
    propagatedBuildInputs = [
      core
      ppx_jane
      ounit
    ];
  };

  higher_kinded = janePackage {
    pname = "higher_kinded";
    hash = "sha256-aCpYc7f4mrPsGp038YabEyw72cA6GbCKsok+5Hej5P0=";
    meta.description = "Library with an encoding of higher kinded types in OCaml";
    propagatedBuildInputs = [
      base
      ppx_jane
    ];
  };

  incr_dom = janePackage {
    pname = "incr_dom";
    hash = "sha256-fnD/YnaGK6MIy/fL6bDwcoGDJhHo2+1l8dCXxwN28kg=";
    meta.description = "Library for building dynamic webapps, using Js_of_ocaml";
    buildInputs = [ js_of_ocaml-ppx ];
    propagatedBuildInputs = [
      async_js
      incr_map
      incr_select
      virtual_dom
    ];
  };

  incr_map = janePackage {
    pname = "incr_map";
    hash = "sha256-D3ZD0C4YfZOfXw+3CtqL8DKcz+b06UL8AF7Rf9x+hps=";
    meta.description = "Helpers for incremental operations on map like data structures";
    buildInputs = [ ppx_pattern_bind ];
    propagatedBuildInputs = [
      abstract_algebra
      bignum
      diffable
      incremental
      streamable
    ];
  };

  incr_select = janePackage {
    pname = "incr_select";
    hash = "sha256-gRUF0QsDaZfHU7Mexl5nR8xCN+65v28/r/ciueR5NdE=";
    meta.description = "Handling of large set of incremental outputs from a single input";
    propagatedBuildInputs = [ incremental ];
  };

  incremental = janePackage {
    pname = "incremental";
    hash = "sha256-PXGY0M2xeVWDLeS3SrqXy1dqsyeKgndGT6NpuiyNQQQ=";
    meta.description = "Library for incremental computations";
    propagatedBuildInputs = [
      core_kernel
      lru_cache
    ];
  };

  indentation_buffer = janePackage {
    pname = "indentation_buffer";
    hash = "sha256-5ayWs7yUnuxh5S3Dp0GbYTkGXttDMomfZak4MHePFbk=";
    meta.description = "Library for building strings with indentation";
    propagatedBuildInputs = [
      core
      ppx_jane
    ];
  };

  int_repr = janePackage {
    pname = "int_repr";
    hash = "sha256-lghu2U1JwZaR4dkd9PcJEW3pZSPoaFhUluIDwFAYFK0=";
    meta.description = "Integers of various widths";
    propagatedBuildInputs = [
      base
      ppx_jane
    ];
  };

  janestreet_cpuid = janePackage {
    pname = "janestreet_cpuid";
    hash = "sha256-lN8+8uhcVn3AoApWzqeCe/It1G6f0VgZzFcwFEckejk=";
    meta.description = "Library for parsing CPU capabilities out of the `cpuid` instruction";
    propagatedBuildInputs = [
      core
      core_kernel
      ppx_jane
    ];
  };

  janestreet_csv = janePackage {
    pname = "janestreet_csv";
    hash = "sha256-XLyHxVlgBvMIBrG2wzOudbKqy+N12Boheb3K+6o9y1o=";
    propagatedBuildInputs = [
      async
      bignum
      core_kernel
      core_unix
      csvfields
      delimited_parsing
      fieldslib
      numeric_string
      ppx_jane
      re2
      textutils
      tyxml
      ocaml_pcre
    ];
    meta.description = "Tools for working with CSVs on the command line";
  };

  jane_rope = janePackage {
    pname = "jane_rope";
    hash = "sha256-MpjbwV+VS3qRuW8kxhjGzsITEdrPeWyr0V+LiKR6U8U=";
    meta.description = "String representation with cheap concatenation";
    propagatedBuildInputs = [
      base
      ppx_jane
    ];
  };

  jane-street-headers = janePackage {
    pname = "jane-street-headers";
    hash = "sha256-vS6tPg8LJolte/zI5KHFYCtNuZjn//cmd94Wls3bLCU=";
    meta.description = "Jane Street C header files";
  };

  js_of_ocaml_patches = janePackage {
    pname = "js_of_ocaml_patches";
    hash = "sha256-Uj+X/0XUP5Za8NKfHGo9OZnqzKCiuurYJyluD6b0wOQ=";
    meta.description = "Additions to js_of_ocaml's standard library that are required by Jane Street libraries";
    propagatedBuildInputs = [
      js_of_ocaml
      js_of_ocaml-ppx
    ];
  };

  jsonaf = janePackage {
    pname = "jsonaf";
    hash = "sha256-Gn54NUg4YOyrXY5kXCZhHFz24CfUT9c55cJ2sOsNVw8=";
    meta.description = "Library for parsing, manipulating, and serializing data structured as JSON";
    propagatedBuildInputs = [
      base
      ppx_jane
      angstrom
      faraday
    ];
  };

  jst-config = janePackage {
    pname = "jst-config";
    hash = "sha256-GviY+zYza7UNYOlAnfAz0aH4LH2B5xA+7iELLuZLgQQ=";
    meta.description = "Compile-time configuration for Jane Street libraries";
    buildInputs = [
      dune-configurator
      ppx_assert
      stdio
    ];
  };

  krb = janePackage {
    pname = "krb";
    hash = "sha256-+XwYKwpl668fZ23YEbL1wW9PlaIIjbP/hHwNanf3dAY=";
    meta.description = "Library for using Kerberos for both Rpc and Tcp communication";
    propagatedBuildInputs = [
      async
      base
      core
      env_config
      hex_encode
      ppx_jane
      protocol_version_header
      username_kernel
      dune-configurator
      krb5
    ];
  };

  lru_cache = janePackage {
    pname = "lru_cache";
    hash = "sha256-FqOBC4kBL9IuFIL4JrVU7iF1AUu+1R/CchR52eyEsa8=";
    meta.description = "LRU cache implementation";
    propagatedBuildInputs = [
      core_kernel
      ppx_jane
    ];
  };

  man_in_the_middle_debugger = janePackage {
    pname = "man_in_the_middle_debugger";
    hash = "sha256-b2A/ITf9gx3thSdEY2n7jxKrMOVDpzx4JkSMB3aTyE4=";
    meta.description = "Man-in-the-middle debugging library";
    propagatedBuildInputs = [
      async
      core
      ppx_jane
      angstrom
      angstrom-async
    ];
  };

  n_ary = janePackage {
    pname = "n_ary";
    hash = "sha256-ofstQs5R25NTP4EtBIzDE/Mzg9ZzAJKfAF838uu0zuE=";
    meta.description = "Library for N-ary datatypes and operations";
    propagatedBuildInputs = [
      base
      expect_test_helpers_core
      ppx_compare
      ppx_enumerate
      ppx_hash
      ppx_jane
      ppx_sexp_conv
      ppx_sexp_message
    ];
  };

  numeric_string = janePackage {
    pname = "numeric_string";
    hash = "sha256-MzRPXMR4Pi07mfJQgOV6R1Z22y2tvQTCq22+00aY1ik=";
    meta.description = "Comparison function for strings that sorts numeric fragments of strings according to their numeric value";
    propagatedBuildInputs = [
      base
      ppx_jane
    ];
  };

  ocaml-compiler-libs = janePackage (
    {
      pname = "ocaml-compiler-libs";
      minimalOCamlVersion = "4.04.1";
      meta.description = "OCaml compiler libraries repackaged";
    }
    // (
      if lib.versionAtLeast ocaml.version "5.2" then
        {
          version = "0.17.0";
          hash = "sha256-QaC6BWrpFblra6X1+TrlK+J3vZxLvLJZ2b0427DiQzM=";
        }
      else
        {
          version = "0.12.4";
          hash = "00if2f7j9d8igdkj4rck3p74y17j6b233l91mq02drzrxj199qjv";
        }
    )
  );

  ocaml-embed-file = janePackage {
    pname = "ocaml-embed-file";
    hash = "sha256-rs+68VATumUgZQ9QrG+By5yNc8cy7avL0BDeqwix0co=";
    propagatedBuildInputs = [
      async
      ppx_jane
    ];
    meta.description = "Files contents as module constants";
  };

  ocaml_intrinsics = janePackage {
    pname = "ocaml_intrinsics";
    hash = "sha256-fbFXTakzxQEeCONSXRXh8FX3HD6h49LZHVsH62Zu3PA=";
    meta.description = "Intrinsics";
    buildInputs = [ dune-configurator ];
    doCheck = false; # test rules broken
  };

  of_json = janePackage {
    pname = "of_json";
    hash = "sha256-qh9mX03Fk9Jb8yox7mZ/CGbWecszK15oaygKbJVDqa0=";
    meta.description = "Friendly applicative interface for Jsonaf";
    buildInputs = [
      core
      core_extended
      jsonaf
      ppx_jane
    ];
  };

  ordinal_abbreviation = janePackage {
    pname = "ordinal_abbreviation";
    hash = "sha256-bGlzFcM6Yw8fcuovrv11WNtAB4mVYv4BjuMlkhsHomQ=";
    meta.description = "Minimal library for generating ordinal names of integers";
    buildInputs = [
      base
      ppx_jane
    ];
  };

  parsexp = janePackage {
    pname = "parsexp";
    hash = "sha256-oc2ASDtUyRBB68tjAoblryAcXF+u3XP1mkQPO5hNbKo=";
    meta.description = "S-expression parsing library";
    propagatedBuildInputs = [
      base
      sexplib0
    ];
  };

  patdiff = janePackage {
    pname = "patdiff";
    hash = "sha256-iVRYKgVBBJws3ZlUwnZt52bIydMtzV7a2R5mjksQAps=";

    # Used by patdiff-git-wrapper.  Providing it here also causes the shebang
    # line to be automatically patched.
    buildInputs = [ bash ];
    propagatedBuildInputs = [
      core_unix
      patience_diff
      ocaml_pcre
    ];
    meta = {
      description = "File Diff using the Patience Diff algorithm";
    };
  };

  patience_diff = janePackage {
    pname = "patience_diff";
    hash = "sha256-JZd99bwLUNhFHng55d77yXSw9u50ahugepesXVdUl04=";
    meta.description = "Diff library using Bram Cohen's patience diff algorithm";
    propagatedBuildInputs = [ core_kernel ];
  };

  polling_state_rpc = janePackage {
    pname = "polling_state_rpc";
    hash = "sha256-l7SMFI+U2rde2OSUNOXPb9NBsvjPrBcxStNooxMgVB8=";
    meta.description = "RPC which tracks state on the client and server so it only needs to send diffs across the wire";
    propagatedBuildInputs = [
      async_kernel
      async_rpc_kernel
      core
      core_kernel
      diffable
      ppx_jane
    ];
  };

  posixat = janePackage {
    pname = "posixat";
    hash = "sha256-Nhp5jiK/TTwQXY5Bm4TTeH+xDTdXtvkSq5CS/Sr1UgA=";
    propagatedBuildInputs = [
      ppx_optcomp
      ppx_sexp_conv
    ];
    meta.description = "Binding to the posix *at functions";
  };

  ppx_accessor = janePackage {
    version = "0.16.1";
    pname = "ppx_accessor";
    hash = "sha256-o70q8eSbPeuGkIcCnKoK0BpaqPhy/NS7x2YYR6wfki8=";
    meta.description = "[@@deriving] plugin to generate accessors for use with the Accessor libraries";
    propagatedBuildInputs = [ accessor ];
  };

  ppx_assert = janePackage {
    pname = "ppx_assert";
    hash = "sha256-LrpKE0BlFC3QseSXf5WhI71blshUzhH8yo2nXjAtiB8=";
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
    hash = "sha256-Ak+7+33qEGYwZWbES032SdkFOsae0+tWtR/DV+xrB10=";
    meta.description = "Base set of ppx rewriters";
    propagatedBuildInputs = [
      ppx_cold
      ppx_enumerate
      ppx_globalize
      ppx_hash
    ];
  };

  ppx_bench = janePackage {
    pname = "ppx_bench";
    hash = "sha256-NZlzEMruf89NsI4jfQJLSPhjk/PN47hLbJzGEN8GPl8=";
    meta.description = "Syntax extension for writing in-line benchmarks in ocaml code";
    propagatedBuildInputs = [ ppx_inline_test ];
  };

  ppx_bin_prot = janePackage {
    pname = "ppx_bin_prot";
    hash = "sha256-ktfa4umCnLd9oY2WWX/5R7vPB/g7DJX8x3nF9fYLNCQ=";
    meta.description = "Generation of bin_prot readers and writers from types";
    propagatedBuildInputs = [
      bin_prot
      ppx_here
    ];
    doCheck = false; # circular dependency with ppx_jane
  };

  ppx_cold = janePackage {
    pname = "ppx_cold";
    hash = "sha256-boP07qHPbzf4ntLdV18oyID09ZUOfkIn9ZdQ0DvtrUA=";
    meta.description = "Expands [@cold] into [@inline never][@specialise never][@local never]";
    propagatedBuildInputs = [ ppxlib ];
  };

  ppx_compare = janePackage {
    pname = "ppx_compare";
    hash = "sha256-4bZdhyfnzTjH4E303O6GO2jW968ftuXwoE4/x854JOo=";
    meta.description = "Generation of comparison functions from types";
    propagatedBuildInputs = [
      ppxlib
      base
    ];
  };

  ppx_conv_func = janePackage {
    pname = "ppx_conv_func";
    hash = "sha256-HPHSZHdR9ll+7EbWc36shTdRPFYB0lkApidk+XL3clI=";
    meta.description = "Part of the Jane Street's PPX rewriters collection";
    propagatedBuildInputs = [
      ppxlib
      base
    ];
  };

  ppx_custom_printf = janePackage {
    pname = "ppx_custom_printf";
    hash = "sha256-V30ijRgcma/rwysPxNAFnuJIb7XFrfi7mfjJxN+rSak=";
    meta.description = "Printf-style format-strings for user-defined string conversion";
    propagatedBuildInputs = [ ppx_sexp_conv ];
  };

  ppx_css = janePackage {
    pname = "ppx_css";
    hash = "sha256-spT/dJW8YJtG4pOku9r6VVlBAMwGakTrr1euiABeqsU=";
    meta.description = "PPX that takes in css strings and produces a module for accessing the unique names defined within";
    propagatedBuildInputs = [
      async
      async_unix
      core_kernel
      core_unix
      ppxlib
      js_of_ocaml
      js_of_ocaml-ppx
      sedlex
      virtual_dom
    ];
    meta.broken = true; # Not compatible with sedlex > 3.4
  };

  ppx_csv_conv = janePackage {
    pname = "ppx_csv_conv";
    hash = "sha256-RdPcDPLzoSf45Zeon3f4HcEvlwB6Q6sAINX3LHmjmj8=";
    meta.description = "Generate functions to read/write records in csv format";
    propagatedBuildInputs = [
      csvfields
      ppx_conv_func
    ];
  };

  ppx_demo = janePackage {
    pname = "ppx_demo";
    hash = "sha256-t/jz94YpwmorhWlcuflIZe0l85cESE62L9I7NMASVWM=";
    meta.description = "PPX that exposes the source code string of an expression/module structure";
    propagatedBuildInputs = [
      core
      dedent
      ppx_jane
      ppxlib
    ];
  };

  ppx_derive_at_runtime = janePackage {
    pname = "ppx_derive_at_runtime";
    hash = "sha256-UESWOkyWTHJlsE6KZkty9P+iHI3oY1rLve3raRAqMbk=";
    meta.description = "Define a new ppx deriver by naming a runtime module";
    propagatedBuildInputs = [
      base
      expect_test_helpers_core
      ppx_jane
      ppxlib
    ];
  };

  ppx_disable_unused_warnings = janePackage {
    pname = "ppx_disable_unused_warnings";
    hash = "sha256-jVNXmAy/Ti7MZmbdBjFuDwbmIILJB57flmmB6MoyCtY=";
    meta.description = "Expands [@disable_unused_warnings] into [@warning \"-20-26-32-33-34-35-36-37-38-39-60-66-67\"]";
    propagatedBuildInputs = [ ppxlib ];
  };

  ppx_enumerate = janePackage {
    pname = "ppx_enumerate";
    hash = "sha256-v5JPu+qEXoZ1+mu/yTZW2sfCzU0K60/sInG/Ox1D35s=";
    meta.description = "Generate a list containing all values of a finite type";
    propagatedBuildInputs = [ ppxlib ];
  };

  ppx_expect = janePackage {
    pname = "ppx_expect";
    hash = "sha256-H5ybRHufycdyCxKu370+QZAMUPQsHVD+6nD93tzvLn8=";
    meta.description = "Cram like framework for OCaml";
    propagatedBuildInputs = [
      ppx_here
      ppx_inline_test
      re
    ];
    doCheck = false; # test build rules broken
  };

  ppx_fields_conv = janePackage {
    pname = "ppx_fields_conv";
    hash = "sha256-kl0JZocMWo2KNciCWkT4nIbJZbh56ijZmlZWbxV8Qj0=";
    meta.description = "Generation of accessor and iteration functions for ocaml records";
    propagatedBuildInputs = [
      fieldslib
      ppxlib
    ];
  };

  ppx_fixed_literal = janePackage {
    pname = "ppx_fixed_literal";
    hash = "sha256-vS2KcCO0fVCmiIBkUBgK6qnqdjREj57QCujHERcJTyo=";
    meta.description = "Simpler notation for fixed point literals";
    propagatedBuildInputs = [ ppxlib ];
  };

  ppx_globalize = janePackage {
    pname = "ppx_globalize";
    hash = "sha256-SG7710YPwWmhRVl7wN3ZQz3ZMTw3cpoywVSeVQAI3Zc=";
    meta.description = "PPX rewriter that generates functions to copy local values to the global heap";
    propagatedBuildInputs = [
      base
      ppxlib
    ];
  };

  ppx_hash = janePackage {
    pname = "ppx_hash";
    hash = "sha256-ZmdW+q7fak8iG42jRQgZ6chmjHHwrDSy9wg7pq/6zwk=";
    meta.description = "PPX rewriter that generates hash functions from type expressions and definitions";
    propagatedBuildInputs = [
      ppx_compare
      ppx_sexp_conv
    ];
  };

  ppx_here = janePackage {
    pname = "ppx_here";
    hash = "sha256-ULEom0pTusxf2k2hduv+5NVp7pW5doA/e3QGQNJfGoM=";
    meta.description = "Expands [%here] into its location";
    propagatedBuildInputs = [ ppxlib ];
    doCheck = false; # test build rules broken
  };

  ppx_ignore_instrumentation = janePackage {
    pname = "ppx_ignore_instrumentation";
    hash = "sha256-rAdxCgAKz0jNR8ppRJO4oAEvgXbcU4J4mpreAyeGe6k=";
    meta.description = "Ignore Jane Street specific instrumentation extensions";
    propagatedBuildInputs = [ ppxlib ];
  };

  ppx_inline_test = janePackage {
    pname = "ppx_inline_test";
    hash = "sha256-Ql0/80KitKvW3xffeCapYREmZvlg+QWCb2JM2T4Rjlc=";
    meta.description = "Syntax extension for writing in-line tests in ocaml code";
    propagatedBuildInputs = [
      ppxlib
      time_now
    ];
    doCheck = false; # test build rules broken
  };

  ppx_jane = janePackage {
    pname = "ppx_jane";
    hash = "sha256-v+/wdEGaXdMWDBa0eJO0uR18G/pDwHjsjaskoEuLusA=";
    meta.description = "Standard Jane Street ppx rewriters";
    propagatedBuildInputs = [
      base_quickcheck
      ppx_bin_prot
      ppx_disable_unused_warnings
      ppx_expect
      ppx_fixed_literal
      ppx_ignore_instrumentation
      ppx_log
      ppx_module_timer
      ppx_optcomp
      ppx_optional
      ppx_pipebang
      ppx_stable
      ppx_string
      ppx_tydi
      ppx_typerep_conv
      ppx_variants_conv
    ];
  };

  ppx_jsonaf_conv = janePackage {
    pname = "ppx_jsonaf_conv";
    hash = "sha256-GWDhSLtr2+VG3XFIbHgWUcLJFniC7/z90ndiE919CBo=";
    meta.description = "[@@deriving] plugin to generate Jsonaf conversion functions";
    propagatedBuildInputs = [
      base
      jsonaf
      ppx_jane
      ppxlib
    ];
  };

  ppx_js_style = janePackage {
    pname = "ppx_js_style";
    hash = "sha256-q5CLyeu+5qjegLrJkQVMnId3HMvZ8j3c0PqEa2vTBtU=";
    meta.description = "Code style checker for Jane Street Packages";
    propagatedBuildInputs = [
      octavius
      ppxlib
    ];
  };

  ppx_let = janePackage {
    pname = "ppx_let";
    hash = "sha256-/kEkYXFZ5OyTM4i/WWViaxKvigpoKKoiWtUWuEMkgBE=";
    meta.description = "Monadic let-bindings";
    propagatedBuildInputs = [
      ppxlib
      ppx_here
    ];
  };

  ppx_log = janePackage {
    pname = "ppx_log";
    hash = "sha256-/HwoxBWKuVqTDYe4u0cYNGqg2Lj0h49U2VrFa4cpE2g=";
    meta.description = "Ppx_sexp_message-like extension nodes for lazily rendering log messages";
    propagatedBuildInputs = [
      base
      ppx_here
      ppx_sexp_conv
      ppx_sexp_message
      sexplib
    ];
  };

  ppx_module_timer = janePackage {
    pname = "ppx_module_timer";
    hash = "sha256-AfG+ZnacrR6p7MOvtktVKVLrMBpNMkX9b2+eqNZNRF4=";
    meta.description = "Ppx rewriter that records top-level module startup times";
    propagatedBuildInputs = [ time_now ];
  };

  ppx_optcomp = janePackage {
    pname = "ppx_optcomp";
    hash = "sha256-TONxBQq/b0kc89f3+jItHd9SnerNx8xa2AjO7HOW+xQ=";
    meta.description = "Optional compilation for OCaml";
    propagatedBuildInputs = [ ppxlib ];
  };

  ppx_optional = janePackage {
    pname = "ppx_optional";
    hash = "sha256-1GpKEEH1Ul+W0k4/8Mra/qYlyFpeMfZ3xrmB3X7uve0=";
    meta.description = "Pattern matching on flat options";
    propagatedBuildInputs = [ ppxlib ];
  };

  ppx_pattern_bind = janePackage {
    pname = "ppx_pattern_bind";
    hash = "sha256-ShR8N71a7sz5XaKDyybsy+K0Uu7sYMgvpMADVxmrI/g=";
    meta.description = "PPX for writing fast incremental bind nodes in a pattern match";
    propagatedBuildInputs = [ ppx_let ];
  };

  ppx_pipebang = janePackage {
    pname = "ppx_pipebang";
    hash = "sha256-gSS+vfsYw3FFOFZ8/iRnP3rxokKAU7EPa1wXq7SbJBk=";
    meta.description = "PPX rewriter that inlines reverse application operators `|>` and `|!`";
    propagatedBuildInputs = [ ppxlib ];
  };

  ppx_python = janePackage {
    pname = "ppx_python";
    hash = "sha256-lpc6F+Scc5ECdOXPWowKSWRnFSzKbmE8oHs7zCjq3j8=";
    meta.description = "[@@deriving] plugin to generate Python conversion functions";
    propagatedBuildInputs = [
      ppx_base
      ppxlib
      pyml
    ];
  };

  ppx_sexp_conv = janePackage {
    pname = "ppx_sexp_conv";
    hash = "sha256-eCQfYAxZZmfNTbPrFW0sqrj63kIdIQ1MAlImCaMop68=";
    meta.description = "[@@deriving] plugin to generate S-expression conversion functions";
    propagatedBuildInputs = [
      ppxlib
      sexplib0
      base
    ];
  };

  ppx_sexp_message = janePackage {
    pname = "ppx_sexp_message";
    hash = "sha256-4g3Fjrjqhw+XNkCyxrXkgZDEa3e+ytPsEtQA2xSv+jA=";
    meta.description = "PPX rewriter for easy construction of s-expressions";
    propagatedBuildInputs = [
      ppx_here
      ppx_sexp_conv
    ];
  };

  ppx_sexp_value = janePackage {
    pname = "ppx_sexp_value";
    hash = "sha256-LsP+deeFYxB38xXw7LLB3gOMGZiUOFRYklGVY7DMmvE=";
    meta.description = "PPX rewriter that simplifies building s-expressions from ocaml values";
    propagatedBuildInputs = [
      ppx_here
      ppx_sexp_conv
    ];
  };

  ppx_stable = janePackage {
    pname = "ppx_stable";
    hash = "sha256-DFCBJY+Q8LjXSF9vHwPpUJLNyMoAXdDwQZrvhl+9g0U=";
    meta.description = "Stable types conversions generator";
    propagatedBuildInputs = [ ppxlib ];
  };

  ppx_stable_witness = janePackage {
    pname = "ppx_stable_witness";
    hash = "sha256-W1CN4xspM8NJiXfi7OsngfzWnLEUmBs+IRLwHfxX9d4=";
    meta.description = "Ppx extension for deriving a witness that a type is intended to be stable";
    propagatedBuildInputs = [
      base
      ppxlib
    ];
  };

  ppx_string = janePackage {
    pname = "ppx_string";
    hash = "sha256-GQlgiaES8wc6Y7rTgmPrf9UfMfu125VoNGEbdc7kFsk=";
    meta.description = "Ppx extension for string interpolation";
    propagatedBuildInputs = [
      ppx_base
      ppxlib
      stdio
    ];
  };

  ppx_tydi = janePackage {
    pname = "ppx_tydi";
    hash = "sha256-neu2Z7TgQdBzf8UtYDRhnGp3Iggfd90Fr+gQuwVTMOo=";
    meta.description = "Let expressions, inferring pattern type from expression";
    propagatedBuildInputs = [
      base
      ppxlib
    ];
  };

  ppx_typed_fields = janePackage {
    pname = "ppx_typed_fields";
    hash = "sha256-l4lCQ4n5FLPS82sb3FgW+HF2OEY/kY10sNfr+aQF8x8=";
    meta.description = "GADT-based field accessors and utilities";
    propagatedBuildInputs = [
      core
      ppx_jane
      ppxlib
    ];
  };

  ppx_typerep_conv = janePackage {
    pname = "ppx_typerep_conv";
    hash = "sha256-DxjgwZee0jOea7qyPfEhRrdcKWQb2jtjrowiJszS+Fs=";
    meta.description = "Generation of runtime types from type declarations";
    propagatedBuildInputs = [
      ppxlib
      typerep
    ];
  };

  ppx_variants_conv = janePackage {
    pname = "ppx_variants_conv";
    hash = "sha256-Q/CCcMrD+XN5YRMzKvXuiQHfcwXwI773s8x150/eMzs=";
    meta.description = "Generation of accessor and iteration functions for ocaml variant types";
    propagatedBuildInputs = [
      variantslib
      ppxlib
    ];
  };

  pythonlib = janePackage {
    pname = "pythonlib";
    version = "0.16";
    hash = "sha256-HrsdtwPSDSaMB9CDIR9P5iaAmLihUrReuNAPIYa+s3Y=";
    meta.description = "Library to help writing wrappers around ocaml code for python";
    propagatedBuildInputs = [
      base
      core
      expect_test_helpers_core
      ppx_compare
      ppx_expect
      ppx_here
      ppx_let
      ppx_python
      ppx_string
      stdio
      typerep
      pyml
    ];
    meta.broken = lib.versionAtLeast ocaml.version "4.14";
  };

  profunctor = janePackage {
    pname = "profunctor";
    hash = "sha256-CFHMtCuBnrlr+B2cdJm2Tamt0A/e+f3SnjEavvE31xQ=";
    meta.description = "Library providing a signature for simple profunctors and traversal of a record";
    propagatedBuildInputs = [
      base
      ppx_jane
      record_builder
    ];
  };

  protocol_version_header = janePackage {
    pname = "protocol_version_header";
    hash = "sha256-GVjnwne6ksjY9ptLOpbsgG0La6eiCJf1w4teYEtgJrA=";
    meta.description = "Protocol versioning";
    propagatedBuildInputs = [ core_kernel ];
  };

  re2 = janePackage {
    pname = "re2";
    hash = "sha256-ZRJ7ooXtatEEh0sPL8M9OZ+6s7xNdTuw0Ot6txiG16I=";
    meta.description = "OCaml bindings for RE2, Google's regular expression library";
    propagatedBuildInputs = [
      core_kernel
      jane_rope
      regex_parser_intf
    ];
    prePatch = ''
      substituteInPlace src/re2_c/dune --replace 'CXX=g++' 'CXX=c++'
      substituteInPlace src/dune --replace '(cxx_flags (:standard \ -pedantic) (-I re2_c/libre2))' '(cxx_flags (:standard \ -pedantic) (-I re2_c/libre2) (-x c++))'
    '';
  };

  re2_stable = janePackage {
    pname = "re2_stable";
    version = "0.14.0";
    hash = "sha256-gyet2Pzn7ZIqQ+UP2J51pRmwaESY2LSGTqCMZZwDTE4=";
    meta.description = "Re2_stable adds an incomplete but stable serialization of Re2";
    propagatedBuildInputs = [
      core
      re2
    ];
  };

  record_builder = janePackage {
    pname = "record_builder";
    hash = "sha256-46zGgN9RlDjoSbi8RimuQVrMhy65Gpic0YPZpHOeoo0=";
    meta.description = "Library which provides traversal of records with an applicative";
    propagatedBuildInputs = [
      base
      ppx_jane
    ];
  };

  redis-async = janePackage {
    pname = "redis-async";
    hash = "sha256-5msIS2m8nkaprR8NEBfKFWZBWaDJiUtjHbfPelg9/os=";
    meta.description = "Redis client for Async applications";
    propagatedBuildInputs = [
      async
      bignum
      core
      core_kernel
      ppx_jane
    ];
  };

  regex_parser_intf = janePackage {
    pname = "regex_parser_intf";
    hash = "sha256-huzHtUIIVRd5pE7VU1oUjN20S55L6+WCvoLlQ0FCD7A=";
    meta.description = "Interface shared by Re_parser and Re2.Parser";
    propagatedBuildInputs = [ base ];
  };

  resource_cache = janePackage {
    pname = "resource_cache";
    hash = "sha256-dN4skSHswgRYLZqN/tqhFFTfgoN8H/LgTgoe+5ZI5zE=";
    meta.description = "General resource cache";
    propagatedBuildInputs = [ async_rpc_kernel ];
  };

  semantic_version = janePackage {
    pname = "semantic_version";
    hash = "sha256-KJanaDUW56ndvnTlnPeQgh0C7zsRqXJ328gcEiVDrmc=";
    meta.description = "Semantic versioning";
    propagatedBuildInputs = [
      core
      ppx_jane
      re
    ];
  };

  sexp = janePackage {
    pname = "sexp";
    hash = "sha256-JWRYi5lX9UOKg+RGvW6FO61t2HlnJKXhzctOHXe0bCM=";
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
      shell
    ];
    meta.description = "S-expression swiss knife";
  };

  sexp_grammar = janePackage {
    pname = "sexp_grammar";
    hash = "sha256-Y/abRingL4+3qvaKgW9jH46E9uq7jYE2+kgr8ERKqfI=";
    propagatedBuildInputs = [
      core
      ppx_bin_prot
      ppx_compare
      ppx_hash
      ppx_let
      ppx_sexp_conv
      ppx_sexp_message
      zarith
    ];
    meta.description = "Helpers for manipulating [Sexplib.Sexp_grammar] values";
  };

  sexp_diff = janePackage {
    pname = "sexp_diff";
    hash = "sha256-2dMBKf7eUbKZtvV7Ol2mPMzYJOCDHuOm9xFZ8vkmp/0=";
    propagatedBuildInputs = [ core_kernel ];
    meta.description = "Code for computing the diff of two sexps";
  };

  sexp_macro = janePackage {
    pname = "sexp_macro";
    hash = "sha256-x9WsFFrV7wUqgPUw8KkfyzOxLrS5h5++OSK8QljeQqg=";
    propagatedBuildInputs = [
      async
      sexplib
    ];
    meta.description = "Sexp macros";
  };

  sexp_pretty = janePackage {
    pname = "sexp_pretty";
    hash = "sha256-tcWdYZ717LkGowRSRoEcUNY7VCMX64uhCaY3bXhWxKM=";
    meta.description = "S-expression pretty-printer";
    propagatedBuildInputs = [
      ppx_base
      re
      sexplib
    ];
  };

  sexp_select = janePackage {
    pname = "sexp_select";
    hash = "sha256-HEzZowojeK9yDOoTY/l01fYLUdolzQGlMO9u3phV8so=";
    propagatedBuildInputs = [
      base
      ppx_jane
    ];
    meta.description = "Library to use CSS-style selectors to traverse sexp trees";
  };

  sexplib0 = janePackage {
    pname = "sexplib0";
    hash = "sha256-wRr1M243Bqu/XLSsr5IVPH5RTVWeVgZjxkKOrm+PW5E=";
    minimalOCamlVersion = "4.08.0";
    meta.description = "Library containing the definition of S-expressions and some base converters";
  };

  sexplib = janePackage {
    pname = "sexplib";
    hash = "sha256-6MwggpjHo4FmKF88fP56LN9OHi2uIJc13TvKx4T7gEI=";
    meta.description = "Library for serializing OCaml values to and from S-expressions";
    propagatedBuildInputs = [
      num
      parsexp
    ];
  };

  shell = janePackage {
    pname = "shell";
    hash = "sha256-pK434+ToeYURQHRV+gK57rC7BFvznWEvIu5NAib2ZTU=";
    meta.description = "Yet another implementation of fork&exec and related functionality";
    buildInputs = [ jst-config ];
    propagatedBuildInputs = [ textutils ];
    checkInputs = [ ounit ];
  };

  shexp = janePackage {
    pname = "shexp";
    hash = "sha256-npIcrxMOcIgsecdUEx5XHYp0KVrXiMzMLi8jskAp4vo=";
    propagatedBuildInputs = [
      posixat
      spawn
    ];
    meta.description = "Process library and s-expression based shell";
  };

  spawn = janePackage {
    pname = "spawn";
    minimalOCamlVersion = "4.02.3";
    version = "0.15.0";
    hash = "1fjr91psas5zmk1hxvxh0dchhn0pkyzlr4gg232f5g9vdgissi0p";
    meta.description = "Spawning sub-processes";
    buildInputs = [ ppx_expect ];
  };

  splay_tree = janePackage {
    pname = "splay_tree";
    hash = "sha256-Ag6yqTofEZ3v0qF+Z7xpXQOh7+HWtvRLlY+iAYqcReg=";
    meta.description = "Splay tree implementation";
    propagatedBuildInputs = [ core_kernel ];
  };

  splittable_random = janePackage {
    pname = "splittable_random";
    hash = "sha256-wMmLuzhKmnS2iTYVTPUx5Rv2LhL/ygmWmb9t2pUjz+E=";
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
    hash = "sha256-+QgxqSMqO4VGoMWWJ3QoXdtJKcVpxlSQ/OI7dmcNqjw=";
    meta.description = "Standard IO library for OCaml";
    propagatedBuildInputs = [ base ];
  };

  stored_reversed = janePackage {
    pname = "stored_reversed";
    hash = "sha256-ef11f0qifEvxKChM49Hnfk6J6hL+b0tMlm0iDLd5Y0Q=";
    meta.description = "Library for representing a list temporarily stored in reverse order";
    propagatedBuildInputs = [
      core
      ppx_jane
    ];
  };

  streamable = janePackage {
    version = "0.16.1";
    pname = "streamable";
    hash = "sha256-3djrUW2tPKaEmoOIpdjN6ok7U9i07yreqbi1kP+6pnY=";
    meta.description = "Collection of types suitable for incremental serialization";
    propagatedBuildInputs = [
      async_kernel
      async_rpc_kernel
      base
      core
      core_kernel
      ppx_jane
      ppxlib
    ];
  };

  textutils = janePackage {
    pname = "textutils";
    hash = "sha256-2qy99MUMpkuNCvCYlk36k4kN6cPjrEILbwEUv4DyNYw=";
    meta.description = "Text output utilities";
    propagatedBuildInputs = [
      core_unix
      textutils_kernel
    ];
  };

  textutils_kernel = janePackage {
    pname = "textutils_kernel";
    hash = "sha256-DiXemANj5ONmvMzp+tly3AJud5u9i7HdaHmn8aVQS48=";
    meta.description = "Text output utilities";
    propagatedBuildInputs = [
      core
      ppx_jane
      uutf
    ];
  };

  tilde_f = janePackage {
    pname = "tilde_f";
    hash = "sha256-qLjM9liJfMIh2fqRPBdnmtUf4xhzk2MY8dFNdON3Aew=";
    meta.description = "Provides a let-syntax for continuation-passing style";
    propagatedBuildInputs = [
      base
      ppx_jane
    ];
  };

  time_now = janePackage {
    pname = "time_now";
    hash = "sha256-DjSrx/HgwCYS0Xzm2gFvWUVLD7a1KuFVIyVrJjBi8Tc=";
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
    hash = "sha256-pmXUMvLfgAwP6TV/aP9wMlOs0KfwEWtaJfdjUFLbOu0=";
    meta.description = "Time-zone handling";
    propagatedBuildInputs = [ core_kernel ];
  };

  topological_sort = janePackage {
    pname = "topological_sort";
    hash = "sha256-um5++60mR++iHAruKqoQfd4EbQ1kb3L+cPOWhs9sIHI=";
    meta.description = "Topological sort algorithm";
    propagatedBuildInputs = [
      ppx_jane
      stdio
    ];
  };

  typerep = janePackage {
    pname = "typerep";
    hash = "sha256-iJnIjWZYCTaH29x7nFviCrbnTmHRChZkkj6E5sgi4mU=";
    meta.description = "Typerep is a library for runtime types";
    propagatedBuildInputs = [ base ];
  };

  username_kernel = janePackage {
    pname = "username_kernel";
    hash = "sha256-UvFL/M9OsD+SOs9MYMKiKzZilLJHzriop6SPA4bOhZQ=";
    meta.description = "Identifier for a user";
    propagatedBuildInputs = [
      core
      ppx_jane
    ];
  };

  variantslib = janePackage {
    pname = "variantslib";
    hash = "sha256-8NoNkyIP7iEEiei+Q1zrPoJjnWwhCsLsY1vgua22gnw=";
    meta.description = "Part of Jane Street's Core library";
    propagatedBuildInputs = [ base ];
  };

  vcaml = janePackage {
    pname = "vcaml";
    hash = "sha256-pmEKi24+22T76SzI3RpBmQF7ZrQwlngrpFYLoBdLwe0=";
    meta.description = "OCaml bindings for the Neovim API";
    propagatedBuildInputs = [
      angstrom-async
      async_extra
      expect_test_helpers_async
      faraday
      jsonaf
      man_in_the_middle_debugger
      semantic_version
    ];
    patches = [ ./vcaml.patch ];
  };

  virtual_dom = janePackage {
    pname = "virtual_dom";
    hash = "sha256-nXW9cDHQVugriR0+GkayuV4S3HKothQAoNJef02iALM=";
    meta.description = "OCaml bindings for the virtual-dom library";
    buildInputs = [ js_of_ocaml-ppx ];
    propagatedBuildInputs = [
      base64
      core_kernel
      gen_js_api
      js_of_ocaml
      js_of_ocaml_patches
      lambdasoup
      tyxml
      uri
    ];
  };

  zarith_stubs_js = janePackage {
    pname = "zarith_stubs_js";
    hash = "sha256-oKD+JE08Mgvk5l8XFHSZ7xqiWPaOvKC87+zHLaQ/7q0=";
    meta.description = "Javascripts stubs for the Zarith library";
  };

  zstandard = janePackage {
    pname = "zstandard";
    hash = "sha256-QcYqlOpCAr0owmO6sLDJhki8lUnNvtkaxldKb5I5AF0=";
    meta.description = "OCaml bindings to Zstandard";
    buildInputs = [ ppx_jane ];
    propagatedBuildInputs = [
      core_kernel
      ctypes
      zstd
    ];
  };

}
