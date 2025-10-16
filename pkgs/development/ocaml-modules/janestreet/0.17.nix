{
  self,
  bash,
  fetchpatch,
  fzf,
  lib,
  openssl,
  zstd,
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
    hash = "sha256-W2rSSbppNkulCgGeTiovzP5zInPWIVfflDxWkGpEOFA=";
    meta.description = "Small library describing abstract algebra concepts";
    propagatedBuildInputs = [
      base
      ppx_jane
    ];
  };

  accessor = janePackage {
    pname = "accessor";
    hash = "sha256-1inoFwDDhnfhW+W3aAkcFNUkf5Umy8BDGDEbMty+Fts=";
    meta.description = "Library that makes it nicer to work with nested functional data structures";
    propagatedBuildInputs = [ higher_kinded ];
  };

  accessor_async = janePackage {
    pname = "accessor_async";
    hash = "sha256-EYyxZur+yshYaX1EJbWc/bCaAa9PDKiuK87fIeqhspo=";
    meta.description = "Accessors for Async types, for use with the Accessor library";
    propagatedBuildInputs = [
      accessor_core
      async_kernel
    ];
  };

  accessor_base = janePackage {
    pname = "accessor_base";
    hash = "sha256-6LJ8dKPAuaxWinArkPl4OE0eYPqvM7+Ao6jff8jhjXc=";
    meta.description = "Accessors for Base types, for use with the Accessor library";
    propagatedBuildInputs = [ ppx_accessor ];
  };

  accessor_core = janePackage {
    pname = "accessor_core";
    hash = "sha256-ku83ZfLtVI8FvQhrKcnJmhmoNlYcVMKx1tor5N8Nq7M=";
    meta.description = "Accessors for Core types, for use with the Accessor library";
    propagatedBuildInputs = [
      accessor_base
      core_kernel
    ];
  };

  async = janePackage {
    pname = "async";
    hash = "sha256-CwRPH5tFZHJqptdmNwdZvKvSJ1Qr21gV1jaxsa/vFBU=";
    meta.description = "Monadic concurrency library";
    propagatedBuildInputs = [
      async_rpc_kernel
      async_log
      async_unix
      textutils
    ];
    doCheck = false; # we don't have netkit_sockets
  };

  async_durable = janePackage {
    pname = "async_durable";
    hash = "sha256-CAU54j3K47p4hQqAtHJYuAQ0IvZPMQZKFp5J7G+xtjM=";
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
    hash = "sha256-rZUROyYrvtgnI+leTMXuGcw71MfVhqdkfp9EIhAFUnM=";
    meta.description = "Monadic concurrency library";
    propagatedBuildInputs = [ async_kernel ];
  };

  async_find = janePackage {
    pname = "async_find";
    hash = "sha256-byvLJvhq7606gKP1kjLRYe3eonkAG3Vz6wQcsjJOiOE=";
    meta.description = "Directory traversal with Async";
    propagatedBuildInputs = [ async ];
  };

  async_inotify = janePackage {
    pname = "async_inotify";
    hash = "sha256-608G8OKQxqrQdYc1Cfrd8g8WLX6QwSeMUz8ORuSbmA8=";
    meta.description = "Async wrapper for inotify";
    propagatedBuildInputs = [
      async_find
      inotify
    ];
  };

  async_interactive = janePackage {
    pname = "async_interactive";
    hash = "sha256-hC7mLDLtvIEMKLMeDOC5ADiAGJlJqYF35RDI+porsKA=";
    meta.description = "Utilities for building simple command-line based user interfaces";
    propagatedBuildInputs = [ async ];
  };

  async_js = janePackage {
    pname = "async_js";
    hash = "sha256-4t7dJ04lTQ0b6clf8AvtyC8ip43vIcEBXgHJLiRbuGM=";
    meta.description = "Small library that provide Async support for JavaScript platforms";
    buildInputs = [ js_of_ocaml-ppx ];
    propagatedBuildInputs = [
      async_rpc_kernel
      js_of_ocaml
      uri-sexp
    ];
    meta.broken = lib.versionAtLeast ppxlib.version "0.36";
  };

  async_kernel = janePackage {
    pname = "async_kernel";
    hash = "sha256-fEbo7EeOJHnBqTYvC/o2a2x69XPnANbe15v/yv29l/4=";
    meta.description = "Monadic concurrency library";
    propagatedBuildInputs = [ core_kernel ];
  };

  async_log = janePackage {
    pname = "async_log";
    hash = "sha256-XeWC3oC0n4or3EDLrNLWXMWhyhH6kcah0Mdb56rZ5lA=";
    meta.description = "Logging library built on top of Async_unix";
    propagatedBuildInputs = [
      async_kernel
      async_unix
      core
      core_kernel
      ppx_jane
      timezone
    ];
  };

  async_rpc_kernel = janePackage {
    pname = "async_rpc_kernel";
    hash = "sha256-zSqmRgybvWhS9XiNIqgxUjQU8xc9aXM69ZaBq4+r+HA=";
    meta.description = "Platform-independent core of Async RPC library";
    propagatedBuildInputs = [
      async_kernel
      protocol_version_header
    ];
  };

  async_rpc_websocket = janePackage {
    pname = "async_rpc_websocket";
    hash = "sha256-pbgG872Av6rX/CH2sOKgTVR42XpP0xhzdR/Bqoq7bSU=";
    meta.description = "Library to serve and dispatch Async RPCs over websockets";
    propagatedBuildInputs = [
      async_rpc_kernel
      async_websocket
      cohttp_async_websocket
    ];
  };

  async_sendfile = janePackage {
    pname = "async_sendfile";
    hash = "sha256-x2chts7U9hoGW6uvyfpHMkSwCx1JXhHX601Xg92Wk3U=";
    meta.description = "Thin wrapper around [Linux_ext.sendfile] to send full files";
    propagatedBuildInputs = [ async_unix ];
  };

  async_shell = janePackage {
    pname = "async_shell";
    hash = "sha256-/wqfuKiQQufs/KhNtBn8C9AzX7GbP8s8cyWGynJ0m1M=";
    meta.description = "Shell helpers for Async";
    propagatedBuildInputs = [
      async
      shell
    ];
  };

  async_smtp = janePackage {
    pname = "async_smtp";
    hash = "sha256-RWtbg6Vpp71ock8Duya5j9Y89OUY4wRXh0pDOxM1NT4=";
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
    hash = "sha256-7obEoeckwydi2wHBkBmX0LynY1QVCb3sQ/U945eteJo=";
    meta.description = "Async wrappers for SSL";
    buildInputs = [ dune-configurator ];
    propagatedBuildInputs = [
      async
      ctypes
      ctypes-foreign
      openssl
    ];
    patches = fetchpatch {
      url = "https://raw.githubusercontent.com/ocaml/opam-source-archives/main/patches/async_ssl/no-incompatible-pointer-types-017.patch";
      hash = "sha256-bpfIi97/b1hIwsFzsmhFAZV1w8CdaMxXoi72ScSYMjY=";
    };
  };

  async_unix = janePackage {
    pname = "async_unix";
    hash = "sha256-fA1e5AnNe/tMTMZ60jtGUofRi4rh+MmVx81kfhfaBaQ=";
    meta.description = "Monadic concurrency library";
    propagatedBuildInputs = [
      async_kernel
      core_unix
      cstruct
    ];
  };

  async_websocket = janePackage {
    pname = "async_websocket";
    hash = "sha256-22N+QO9hpkKHv3n9WkvtmJouxb/nuauv1UXdVV0zOGA=";
    meta.description = "Library that implements the websocket protocol on top of Async";
    propagatedBuildInputs = [
      async
      cryptokit
    ];
  };

  babel = janePackage {
    pname = "babel";
    hash = "sha256-mRSlLXtaGj8DcdDZGUZbi16qQxtfb+fXkwxz6AXxN3o=";
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
    version = "0.17.2";
    hash = "sha256-GMUlo77IKXwsldZYK5uRcmjj2RyaDhdfFo1KRCJl9Dc=";
    meta.description = "Full standard library replacement for OCaml";
    buildInputs = [ dune-configurator ];
    propagatedBuildInputs = [
      sexplib0
      ocaml_intrinsics_kernel
    ];
    checkInputs = [ alcotest ];
  };

  base_bigstring = janePackage {
    pname = "base_bigstring";
    hash = "sha256-tGDtkVOU10GzNsJ4wZtbqyIMjY5lHM4+rA3+w34TYOE=";
    meta.description = "String type based on [Bigarray], for use in I/O and C-bindings";
    propagatedBuildInputs = [
      int_repr
      ppx_jane
    ];
  };

  base_trie = janePackage {
    pname = "base_trie";
    hash = "sha256-KuVDLJiEIjbvLCNI51iFLlsMli+hspWMyhrMk5pSL58=";
    meta.description = "Trie data structure library";
    propagatedBuildInputs = [
      base
      core
      expect_test_helpers_core
      ppx_jane
    ];
  };

  base_quickcheck = janePackage (
    {
      pname = "base_quickcheck";
      meta.description = "Randomized testing framework, designed for compatibility with Base";
      propagatedBuildInputs = [
        ppx_base
        ppx_fields_conv
        ppx_let
        ppx_sexp_value
        splittable_random
      ];
    }
    // (
      if lib.versionAtLeast ppxlib.version "0.36" then
        {
          version = "0.17.1";
          hash = "sha256-0s40sGu2FvaUjvC5JSvHlRhbyQV1bVPrVTTWdHtTQ+k=";
        }
      else
        {
          version = "0.17.0";
          hash = "sha256-jDxO+/9Qnntt6ZNX1xvaWvoJ0JpnPqeq8X8nsYpeqsY=";
        }
    )
  );

  bidirectional_map = janePackage {
    pname = "bidirectional_map";
    hash = "sha256-LnslyNdgQpa9DOAkwb0qq9/NdRvKNocUTIP+Dni6oYc=";
    meta.description = "Library for bidirectional maps and multimaps";
  };

  bignum = janePackage {
    pname = "bignum";
    hash = "sha256-QhVEZ97n/YUBBXYCshDa5UnZpv0BKK6xRN1kXabY3Es=";
    propagatedBuildInputs = [
      core_kernel
      zarith
      zarith_stubs_js
    ];
    meta.description = "Core-flavoured wrapper around zarith's arbitrary-precision rationals";
  };

  bin_prot = janePackage {
    pname = "bin_prot";
    hash = "sha256-5QeK8Cdu+YjNE/MLiQps6SSf5bRJ/eYZYsJH7oYSarg=";
    meta.description = "Binary protocol generator";
    propagatedBuildInputs = [
      ppx_compare
      ppx_custom_printf
      ppx_fields_conv
      ppx_optcomp
      ppx_stable_witness
      ppx_variants_conv
    ];
    postPatch = ''
      patchShebangs xen/cflags.sh
    '';
  };

  bonsai = janePackage {
    pname = "bonsai";
    hash = "sha256-rr87o/w/a6NtCrDIIYmk2a5IZ1WJM/qJUeDqTLN1Gr4=";
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
      ppx_quick_test
      ppx_typed_fields
      profunctor
      sexp_grammar
      textutils
      versioned_polling_state_rpc
    ];
  };

  capitalization = janePackage {
    pname = "capitalization";
    hash = "sha256-wq8SO+SXF+UQhSu+ElVYv9erZ8S54G3SzJd0HX/Vwyk=";
    meta.description = "Naming conventions for multiple-word identifiers";
    propagatedBuildInputs = [
      base
      ppx_base
    ];
  };

  cinaps = janePackage {
    pname = "cinaps";
    version = "0.15.1";
    hash = "sha256-LycruanldSP251uYJjQqIfI76W0UQ6o5i5u8XjszBT0=";
    meta.description = "Trivial metaprogramming tool";
    minimalOCamlVersion = "4.04";
    propagatedBuildInputs = [ re ];
    # doCheck fails because ppx_base doesn't include ppx_js_style, and this is
    # needed for the ppx executable to parse `-allow-toplevel-expression` flag.
    doCheck = false;
  };

  codicons = janePackage {
    pname = "codicons";
    hash = "sha256-S4VrMObA5+SNeL/XsWU6SoSD/0TVvuqHjthUaQCDoRU=";
    meta.description = "Icons from VS code";
    propagatedBuildInputs = [
      core
      ppx_jane
      virtual_dom
    ];
  };

  cohttp_async_websocket = janePackage {
    pname = "cohttp_async_websocket";
    hash = "sha256-0InGCF34LWQes9S4OgbR6w+6cylThYuj1Dj0aQyTnuY=";
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
    hash = "sha256-RB/sUq1tL8A3m9YhHHx2LFqoExTX187VeZI9MRb1NeA=";
    meta.description = "Library for easily creating a cohttp handler for static files";
    propagatedBuildInputs = [ cohttp-async ];
  };

  content_security_policy = janePackage {
    pname = "content_security_policy";
    hash = "sha256-AQN2JJA+5B0PERNNOA9FXX6rIeej40bwJtQmHP6GKw4=";
    meta.description = "Library for building content-security policies";
    propagatedBuildInputs = [
      base64
      cryptokit
      core
      ppx_jane
    ];
  };

  core = janePackage {
    pname = "core";
    version = "0.17.1";
    hash = "sha256-XkABcvglVJLVnWJmvfr5eVywyclPSDqanVOLQNqdNtQ=";
    meta.description = "Industrial strength alternative to OCaml's standard library";
    buildInputs = [ jst-config ];
    propagatedBuildInputs = [
      base
      base_bigstring
      base_quickcheck
      ppx_diff
      ppx_jane
      time_now
    ];
  };

  core_bench = janePackage {
    pname = "core_bench";
    hash = "sha256-oXE3FuCCIbX2M0r4Ds2BMUU6g1bqe9E87lDo2CcMtMU=";
    meta.description = "Benchmarking library";
    propagatedBuildInputs = [
      core_extended
      delimited_parsing
      textutils
    ];
  };

  core_extended = janePackage {
    pname = "core_extended";
    hash = "sha256-Xl6czD1gdnvHkXDz+qa7TWZq6dm8wlDqywxEIi2R6bI=";
    meta.description = "Extra components that are not as closely vetted or as stable as Core";
    propagatedBuildInputs = [
      core_unix
      record_builder
    ];
  };

  core_kernel = janePackage {
    pname = "core_kernel";
    hash = "sha256-l7U0edUCNHTroYMBHiEMDx5sl7opEmmmeo2Z06tCMts=";
    meta.description = "System-independent part of Core";
    buildInputs = [ jst-config ];
    propagatedBuildInputs = [
      base_bigstring
      core
      int_repr
      sexplib
      uopt
    ];
    doCheck = false; # we don't have quickcheck_deprecated
  };

  core_unix = janePackage {
    pname = "core_unix";
    version = "0.17.1";
    hash = "sha256-xJoBW6TBBnzR5n38E5LHBFYO2CRIsME7OTdEZKn8EqU=";
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
    doCheck = false; # command_validate_parsing.exe is not specified in test build deps

  };

  csvfields = janePackage {
    pname = "csvfields";
    hash = "sha256-hCH2NGQIRTU5U3TUOYHao6Kz5PhnLbySmzic4ytppEc=";
    propagatedBuildInputs = [
      core
      num
    ];
    meta.description = "Runtime support for ppx_xml_conv and ppx_csv_conv";
  };

  dedent = janePackage {
    pname = "dedent";
    hash = "sha256-Scir/gaIhmNowXZ0tv57M/Iv1GXQIkyDks1sU1DAoIQ=";
    propagatedBuildInputs = [
      base
      ppx_jane
      stdio
    ];
    meta.description = "Library for improving readability of multi-line string constants in code";
  };

  delimited_parsing = janePackage {
    pname = "delimited_parsing";
    hash = "sha256-bgt99kQvaU7FPK1+K1UOAUbSaaaCB1DV23Cuo3A68M0=";
    propagatedBuildInputs = [
      async
      core_extended
    ];
    meta.description = "Parsing of character (e.g., comma) separated and fixed-width values";
  };

  legacy_diffable = janePackage {
    pname = "legacy_diffable";
    hash = "sha256-wUSG04bHCnwqXpWKgkceAORs1inxexiPKZIR9fEVmCo=";
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
    hash = "sha256-CEroXMEIAfvXD603bnIVwzcrE3KbVaOOhGZastkQcdU=";
    meta.description = "Library for writing Emacs plugin in OCaml";
    propagatedBuildInputs = [
      async
      expect_test_helpers_core
    ];
  };

  email_message = janePackage {
    pname = "email_message";
    hash = "sha256-1OJ6bQb/rdyfAgMyuKT/ylpa8qBldZV5kEm0B45Ej1w=";
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
    hash = "sha256-vG309p7xqanTnrnHBwvuCO3YD4tVbTNa7F1F9sZDZE0=";
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
    hash = "sha256-oInNgNISqOrmQUXVxzjDy+mS06yPEeFPGIvaKnCETjk=";
    meta.description = "Async helpers for writing expectation tests";
    propagatedBuildInputs = [
      async
      expect_test_helpers_core
    ];
  };

  expect_test_helpers_core = janePackage {
    pname = "expect_test_helpers_core";
    hash = "sha256-vnlDZ8k3JFCdN6WGiaG9OEEdQJnw0/eMogFCfTXIu2Y=";
    meta.description = "Helpers for writing expectation tests";
    propagatedBuildInputs = [
      core_kernel
      sexp_pretty
    ];
  };

  fieldslib = janePackage {
    pname = "fieldslib";
    hash = "sha256-Zfnc32SghjZYTlnSdo6JPm4WCb7BPVjrWNDfeMZHaiU=";
    meta.description = "Syntax extension to define first class values representing record fields, to get and set record fields, iterate and fold over all fields of a record and create new record values";
    propagatedBuildInputs = [ base ];
  };

  file_path = janePackage {
    pname = "file_path";
    hash = "sha256-XSLfYasn6qMZmDzAUGssOM9EX09n2W9/imTgNoSBEyk=";
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
    hash = "sha256-XB1U4mY0LcdsKYRnmV0SR4ODTIZynZetBk5X5SdHs44=";
    meta.description = "Library for fuzzy string matching";
    propagatedBuildInputs = [
      core
      ppx_jane
    ];
  };

  fzf = janePackage {
    pname = "fzf";
    hash = "sha256-yHdvC3cB5sVXsZQbtNzUZkaaqOe/7y8pDHgLwugAlQg=";
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

  gel = janePackage {
    pname = "gel";
    hash = "sha256-zGDlxbJINXD1qG7EifZGDfKbQpehdHyR/WLRJRYlwUg=";
    meta.description = "Library to mark non-record fields global";
    propagatedBuildInputs = [
      base
      ppx_jane
    ];
  };

  hex_encode = janePackage {
    pname = "hex_encode";
    hash = "sha256-5DqaCJllphdEreOpzAjT61qb3M6aN9b2xhiUjHVLrvE=";
    meta.description = "Hexadecimal encoding library";
    propagatedBuildInputs = [
      core
      ppx_jane
      ounit
    ];
  };

  higher_kinded = janePackage {
    pname = "higher_kinded";
    hash = "sha256-6aZxgGzltRs2aS4MYJh23Gpoqcko6xJxU11T6KixXno=";
    meta.description = "Library with an encoding of higher kinded types in OCaml";
    propagatedBuildInputs = [
      base
      ppx_jane
    ];
  };

  incr_dom = janePackage {
    pname = "incr_dom";
    hash = "sha256-dkF7+aq5Idw1ltDgGEjGYspdmOXjXqv8AA27b4M7U8A=";
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
    hash = "sha256-qNahlxe3Pe1EEcFz1bAKUw3vBaNjgDlahQeuj/+VqbI=";
    meta.description = "Helpers for incremental operations on map like data structures";
    buildInputs = [ ppx_pattern_bind ];
    propagatedBuildInputs = [
      abstract_algebra
      bignum
      legacy_diffable
      incremental
      streamable
    ];
  };

  incr_select = janePackage {
    pname = "incr_select";
    hash = "sha256-/VCNiE8Y7LBL0OHd5V+tB/b3HGKhfSvreU6LZgurYAg=";
    meta.description = "Handling of large set of incremental outputs from a single input";
    propagatedBuildInputs = [ incremental ];
  };

  incremental = janePackage {
    pname = "incremental";
    hash = "sha256-siBN36Vv0Bktyxh+8tL6XkUGLqSYMxqvd0UWuTRgAnI=";
    meta.description = "Library for incremental computations";
    propagatedBuildInputs = [
      core_kernel
      lru_cache
    ];
  };

  indentation_buffer = janePackage {
    pname = "indentation_buffer";
    hash = "sha256-/IUZyRkcxUsddzGGIoaLpXbpCxJ1satK79GkzPxSPSc=";
    meta.description = "Library for building strings with indentation";
    propagatedBuildInputs = [
      core
      ppx_jane
    ];
  };

  int_repr = janePackage {
    pname = "int_repr";
    hash = "sha256-yeaAzw95zB1wow9Alg18CU+eemZVxjdLiO/wVRitDwE=";
    meta.description = "Integers of various widths";
    propagatedBuildInputs = [
      base
      ppx_jane
    ];
  };

  janestreet_cpuid = janePackage {
    pname = "janestreet_cpuid";
    hash = "sha256-3ZwEZQSkJJyFW5/+C9x8nW6+GrfVwccNFPlcs7qNcjQ=";
    patches = fetchpatch {
      url = "https://github.com/janestreet/janestreet_cpuid/commit/55223d9708388fe990553669d881f78a811979b9.patch";
      hash = "sha256-aggT6GGMkQj4rRkSZK4hoPRzEfpC8z9qnIROptMDf9E=";
    };
    meta.description = "Library for parsing CPU capabilities out of the `cpuid` instruction";
    propagatedBuildInputs = [
      core
      core_kernel
      ppx_jane
    ];
  };

  janestreet_csv = janePackage {
    pname = "janestreet_csv";
    hash = "sha256-at7ywGDaYIDsqhxxLYJhB8a697ccfPtKKI8LvCmRgG8=";
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
    hash = "sha256-Lo4+ZUX9R2EGrz4BN+LqdJgVXB3hQqNifgwsjFC1Hfs=";
    meta.description = "String representation with cheap concatenation";
    propagatedBuildInputs = [
      base
      ppx_jane
    ];
  };

  jane-street-headers = janePackage {
    pname = "jane-street-headers";
    hash = "sha256-nEa40utpXA3KiFhp9inWurKyDF4Jw1Jlln6fiW5MAkM=";
    meta.description = "Jane Street C header files";
  };

  js_of_ocaml_patches = janePackage {
    pname = "js_of_ocaml_patches";
    hash = "sha256-N61IEZLGfCU3ZX+sw35DAUqUh3u8RaCFcNlXxU1dvL8=";
    meta.description = "Additions to js_of_ocaml's standard library that are required by Jane Street libraries";
    propagatedBuildInputs = [
      js_of_ocaml
      js_of_ocaml-ppx
    ];
    patches = [ ./js_of_ocaml_patches.patch ];
    meta.broken = lib.versionAtLeast ppxlib.version "0.36";
  };

  jsonaf = janePackage {
    pname = "jsonaf";
    hash = "sha256-MMIDHc40cmPpO0n8yREIGMyFndw3NfvGUhy6vHnn40w=";
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
    hash = "sha256-xwQ+q2Hsduu2vWMWFcjoj3H8Es00N7Mv9LwIZG4hw7c=";
    meta.description = "Compile-time configuration for Jane Street libraries";
    buildInputs = [
      dune-configurator
      ppx_assert
      stdio
    ];
  };

  lru_cache = janePackage {
    pname = "janestreet_lru_cache";
    hash = "sha256-/UMSccN9yGAXF7/g6ueSnsfPSnF1fm0zJIRFsThZvH8=";
    meta.description = "LRU cache implementation";
    propagatedBuildInputs = [
      core_kernel
      ppx_jane
    ];
  };

  man_in_the_middle_debugger = janePackage {
    pname = "man_in_the_middle_debugger";
    hash = "sha256-ImEzn/EssgW63vdGhLMp4NB/FW0SsCMQ32ZNAs7bDg4=";
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
    hash = "sha256-xg4xK3m7SoO1P+rBHvPqFMLx9JXnADEeyU58UmAqW6s=";
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
    hash = "sha256-cU5ETGfavkkiqZOjehCYg06YdDk8W+ZDqz17FGWHey8=";
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
          hash = "sha256-W+KUguz55yYAriHRMcQy8gRPzh2TZSJnexG1JI8TLgI=";
        }
    )
  );

  ocaml-embed-file = janePackage {
    pname = "ocaml-embed-file";
    hash = "sha256-7fyZ5DNcRHud0rd4dLUv9Vyf3lMwMVxgkl9jVUn1/lw=";
    propagatedBuildInputs = [
      async
      ppx_jane
    ];
    meta.description = "Files contents as module constants";
  };

  ocaml_intrinsics_kernel = janePackage {
    pname = "ocaml_intrinsics_kernel";
    hash = "sha256-utD9HE0P3vPgSXDW8Bz0FxgEy+lNkIAlN/+JkfDqb9A=";
    meta.description = "Kernel library of intrinsics for OCaml";
    buildInputs = [ dune-configurator ];
  };

  ocaml_intrinsics = janePackage {
    pname = "ocaml_intrinsics";
    hash = "sha256-Ndt6ZPJamBYzr1YA941BLwvRgkkbD8AEQR/JjjR38xI=";
    meta.description = "Library of intrinsics for OCaml";
    buildInputs = [
      dune-configurator
    ];
    propagatedBuildInputs = [
      ocaml_intrinsics_kernel
    ];
    patches = [
      # This patch is needed because of an issue with the aarch64 CRC32
      # intrinsics that was introduced with ocaml_intrinsics v0.17. It should
      # be removed as soon as
      # https://github.com/janestreet/ocaml_intrinsics/pull/11 is merged.
      ./ocaml_intrinsics-fix-aarch64-crc32-intrinsics.patch
    ];
  };

  ocaml_openapi_generator = janePackage {
    pname = "ocaml_openapi_generator";
    hash = "sha256-HCq9fylcVjBMs8L6E860nw+EonWEQadlyEKpQI6mynU=";
    meta.description = "OpenAPI 3 to OCaml client generator";
    buildInputs = [
      async
      core
      core_kernel
      core_unix
      jsonaf
      ppx_jane
      ppx_jsonaf_conv
      httpaf
      jingoo
      uri
    ];
    nativeBuildInputs = [ ocaml-embed-file ];
  };

  of_json = janePackage {
    pname = "of_json";
    hash = "sha256-pZCiwXRwZK6ohsGz/WLacgo48ekdT35uD4VESvGxH8A=";
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
    hash = "sha256-kmTGnGbhdiUoXXw2DEAeZJL2sudEf8BRRt2RHCdL7HU=";
    meta.description = "Minimal library for generating ordinal names of integers";
    buildInputs = [
      base
      ppx_jane
    ];
  };

  parsexp = janePackage {
    pname = "parsexp";
    hash = "sha256-iKrZ6XDLM6eRl7obaniDKK6X8R7Kxry6HD7OQBwh3NU=";
    meta.description = "S-expression parsing library";
    propagatedBuildInputs = [
      base
      sexplib0
    ];
  };

  patdiff = janePackage {
    pname = "patdiff";
    hash = "sha256-iphpQ0b8i+ItY57zM4xL9cID9GYuTCMZN7SYa7TDprI=";

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
    postPatch = ''
      patchShebangs test/bin/setup.sh
    '';
    doCheck = false; # test rules broken
  };

  patience_diff = janePackage {
    pname = "patience_diff";
    hash = "sha256-sn/8SvMt7kzzuYUwhB/uH/3mO1aIKHw/oRYRzA7goFU=";
    meta.description = "Diff library using Bram Cohen's patience diff algorithm";
    propagatedBuildInputs = [ core_kernel ];
  };

  polling_state_rpc = janePackage {
    pname = "polling_state_rpc";
    hash = "sha256-fZKGva11ztuM+q0Lc6rr9NEH/Qo+wFmE6Rr1/TJm7rA=";
    meta.description = "RPC which tracks state on the client and server so it only needs to send diffs across the wire";
    propagatedBuildInputs = [
      async_kernel
      async_rpc_kernel
      babel
      core
      core_kernel
      legacy_diffable
      ppx_jane
    ];
  };

  posixat = janePackage {
    pname = "posixat";
    hash = "sha256-G+5q8x1jfG3wEwNzX2tkcC2Pm4E5/ZYxQyBwCUNXIrw=";
    propagatedBuildInputs = [
      ppx_optcomp
      ppx_sexp_conv
    ];
    meta.description = "Binding to the posix *at functions";
  };

  ppx_accessor = janePackage {
    pname = "ppx_accessor";
    hash = "sha256-vK6lA0J98bDGtVthIdU76ckzH+rpNUD1cQ3vMzHy0Iw=";
    meta.description = "[@@deriving] plugin to generate accessors for use with the Accessor libraries";
    propagatedBuildInputs = [ accessor ];
  };

  ppx_assert = janePackage {
    pname = "ppx_assert";
    hash = "sha256-o9ywdFH6+qoJ3eWb29/gGlkWkHDMuBx626mNxrT1D8A=";
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
    hash = "sha256-/s7c8vfLIO1pPajNldMgurBKXsSzQ8yxqFI6QZCHm5I=";
    meta.description = "Base set of ppx rewriters";
    propagatedBuildInputs = [
      ppx_cold
      ppx_enumerate
      ppx_globalize
      ppx_hash
    ];
  };

  ppx_bench = janePackage (
    {
      pname = "ppx_bench";
      meta.description = "Syntax extension for writing in-line benchmarks in ocaml code";
      propagatedBuildInputs = [ ppx_inline_test ];
    }
    // (
      if lib.versionAtLeast ppxlib.version "0.36" then
        {
          version = "0.17.1";
          hash = "sha256-nHqZSyJ5mZ86SGu9WtoVNfYTnd5kslyI8Zm/LJ7b/Fo=";
        }
      else
        {
          version = "0.17.0";
          hash = "sha256-y4nL/wwjJUL2Fa7Ne0f7SR5flCjT1ra9M1uBHOUZWCg=";
        }
    )
  );

  ppx_bin_prot = janePackage (
    {
      pname = "ppx_bin_prot";
      meta.description = "Generation of bin_prot readers and writers from types";
      propagatedBuildInputs = [
        bin_prot
        ppx_here
      ];
      doCheck = false; # circular dependency with ppx_jane
    }
    // (
      if lib.versionAtLeast ppxlib.version "0.36" then
        {
          version = "0.17.1";
          hash = "sha256-9TNtRwieITJMZs+7RT7tOf1GwVlxuGeKZktVon9B7g4=";
        }
      else
        {
          version = "0.17.0";
          hash = "sha256-nQps/+Csx3+6H6KBzIm/dLCGWJ9fcRD7JxB4P2lky0o=";
        }
    )
  );

  ppx_cold = janePackage {
    pname = "ppx_cold";
    hash = "sha256-fFZqlcbUS7D+GjnxSjGYckkQtx6ZcPNtOIsr6Rt6D9A=";
    meta.description = "Expands [@cold] into [@inline never][@specialise never][@local never]";
    propagatedBuildInputs = [ ppxlib ];
  };

  ppx_compare = janePackage {
    pname = "ppx_compare";
    hash = "sha256-uAXB9cba0IBl+cA2CAuGVVxuos4HXH5jlB6Qjxx44Y0=";
    meta.description = "Generation of comparison functions from types";
    propagatedBuildInputs = [
      ppxlib
      ppxlib_jane
      base
    ];
  };

  ppx_conv_func = janePackage {
    pname = "ppx_conv_func";
    hash = "sha256-PJ8T0u8VkxefaxojwrmbMXDjqyfAIxKe92B8QqRY2JU=";
    meta.description = "Part of the Jane Street's PPX rewriters collection";
    propagatedBuildInputs = [
      ppxlib
      base
    ];
  };

  ppx_custom_printf = janePackage {
    pname = "ppx_custom_printf";
    hash = "sha256-DFgDb9MIFCqglYoMgPUN0zEaxkr7VJAXgLxq1yp8ap4=";
    meta.description = "Printf-style format-strings for user-defined string conversion";
    propagatedBuildInputs = [ ppx_sexp_conv ];
  };

  ppx_css = janePackage {
    pname = "ppx_css";
    hash = "sha256-mzLMVtNTy9NrVaNgsRa+oQynxXnh2qlHJCfr3FLFJ2I=";
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
    hash = "sha256-NtqfagLIYiuyBjEAxilAhATx8acJwD7LykHBzfr+yAc=";
    meta.description = "Generate functions to read/write records in csv format";
    propagatedBuildInputs = [
      csvfields
      ppx_conv_func
    ];
  };

  ppx_demo = janePackage {
    pname = "ppx_demo";
    hash = "sha256-blD96GhicOj3b6jYNniSpq6fBR+ul9Y2kn0ZmfbeVMo=";
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
    hash = "sha256-Y/z4BKFRt3z1lUGdc7SznIv/ys//dZHoPSnsouj1GtI=";
    meta.description = "Define a new ppx deriver by naming a runtime module";
    propagatedBuildInputs = [
      base
      expect_test_helpers_core
      ppx_jane
      ppxlib
    ];
    meta.broken = lib.versionAtLeast ppxlib.version "0.36";
  };

  ppx_diff = janePackage (
    {
      pname = "ppx_diff";
      meta.description = "Generation of diffs and update functions for ocaml types";
      propagatedBuildInputs = [
        base
        gel
        ppx_compare
        ppx_enumerate
        ppx_jane
      ];
    }
    // (
      if lib.versionAtLeast ppxlib.version "0.36" then
        {
          version = "0.17.1";
          hash = "sha256-eWzlEIPjNcxhz2Q5+y7fv9mJDJzauOpJ993CXoy8nh4=";
        }
      else
        {
          version = "0.17.0";
          hash = "sha256-MAn+vcU6vLR8g16Wq1sORyLcLgWxLsazMQY1syY6HsA=";
        }
    )
  );

  ppx_disable_unused_warnings = janePackage {
    pname = "ppx_disable_unused_warnings";
    hash = "sha256-KHWIufXU+k6xCLf8l50Pp/1JZ2wFrKnKT/aQYpadlmU=";
    meta.description = ''Expands [@disable_unused_warnings] into [@warning "-20-26-32-33-34-35-36-37-38-39-60-66-67"]'';
    propagatedBuildInputs = [ ppxlib ];
  };

  ppx_embed_file = janePackage {
    pname = "ppx_embed_file";
    hash = "sha256-Ew6/X7oAq81ldERU37QWXQdgReEtPD/lxbku8WZNJ6A=";
    meta.description = "PPX that allows embedding files directly into executables/libraries as strings or bytes";
    propagatedBuildInputs = [
      core
      ppx_jane
      shell
      ppxlib
    ];
  };

  ppx_enumerate = janePackage {
    pname = "ppx_enumerate";
    hash = "sha256-YqBrxp2fe91k8L3aQVW6egoDPj8onGSRueQkE2Icdu4=";
    meta.description = "Generate a list containing all values of a finite type";
    propagatedBuildInputs = [
      ppxlib
      ppxlib_jane
    ];
  };

  ppx_expect = janePackage (
    {
      pname = "ppx_expect";
      meta.description = "Cram like framework for OCaml";
      propagatedBuildInputs = [
        ppx_here
        ppx_inline_test
        re
      ];
      doCheck = false; # test build rules broken
    }
    // (
      if lib.versionAtLeast ppxlib.version "0.36" then
        {
          version = "0.17.3";
          hash = "sha256-eYZ3p3FYjHd15pj79TKyHSHNKRSWj80iHJFxBZN40s4=";
        }
      else
        {
          version = "0.17.2";
          hash = "sha256-na9n/+shkiHIIUQ2ZitybQ6NNsSS9gWFNAFxij+JNVo=";
        }
    )
  );

  ppx_fields_conv = janePackage {
    pname = "ppx_fields_conv";
    hash = "sha256-FA7hDgqJMJ2obsVwzwaGnNLPvjP0SkTec8Nh3znuNDQ=";
    meta.description = "Generation of accessor and iteration functions for ocaml records";
    propagatedBuildInputs = [
      fieldslib
      ppxlib
    ];
  };

  ppx_fixed_literal = janePackage {
    pname = "ppx_fixed_literal";
    hash = "sha256-Xq+btvZQ/+6bcHoH9DcrrhD5CkwpFeedn7YEFHeLzsU=";
    meta.description = "Simpler notation for fixed point literals";
    propagatedBuildInputs = [ ppxlib ];
  };

  ppx_globalize = janePackage (
    {
      pname = "ppx_globalize";
      meta.description = "PPX rewriter that generates functions to copy local values to the global heap";
      propagatedBuildInputs = [
        base
        ppxlib
        ppxlib_jane
      ];
    }
    // (
      if lib.versionAtLeast ppxlib.version "0.36" then
        {
          version = "0.17.2";
          hash = "sha256-5pHqyv94DXpSG69TEATcnJwFh5YurxVCM5ZPtrlbXSo=";
        }
      else
        {
          version = "0.17.0";
          hash = "sha256-LKV5zfaf6AXn3NzOhN2ka8NtjItPTIsfmoJVBw5bYi8=";
        }
    )
  );

  ppx_hash = janePackage {
    pname = "ppx_hash";
    hash = "sha256-GADCLoF2GjZkvAiezn0xyReCs1avrUgjJGSS/pMNq38=";
    meta.description = "PPX rewriter that generates hash functions from type expressions and definitions";
    propagatedBuildInputs = [
      ppx_compare
      ppx_sexp_conv
    ];
  };

  ppx_here = janePackage {
    pname = "ppx_here";
    hash = "sha256-ybwOcv82uDRPTlfaQgaBJHVq6xBxIRUj07CXP131JsM=";
    meta.description = "Expands [%here] into its location";
    propagatedBuildInputs = [ ppxlib ];
    doCheck = false; # test build rules broken
  };

  ppx_ignore_instrumentation = janePackage {
    pname = "ppx_ignore_instrumentation";
    hash = "sha256-73dp8XKfsLO0Z6A1p5/K7FjxgeUPMBkScx0IjfbOV+w=";
    meta.description = "Ignore Jane Street specific instrumentation extensions";
    propagatedBuildInputs = [ ppxlib ];
  };

  ppx_inline_test = janePackage (
    {
      pname = "ppx_inline_test";
      meta.description = "Syntax extension for writing in-line tests in ocaml code";
      propagatedBuildInputs = [
        ppxlib
        time_now
      ];
      doCheck = false; # test build rules broken
    }
    // (
      if lib.versionAtLeast ppxlib.version "0.36" then
        {
          version = "0.17.1";
          hash = "sha256-wNDDdNUeWTW87HRKbRSuOXaCPQnDWx7/RXuCDISc9Pg=";
        }
      else
        {
          version = "0.17.0";
          hash = "sha256-pNdrmAlT3MUbuPUcMmCRcUIXv4fZ/o/IofJmnUKf8Cs=";
        }
    )
  );

  ppx_jane = janePackage {
    pname = "ppx_jane";
    hash = "sha256-HgIob7iJkV0HcGi6IjjSUWdKOAu2TsC3GMyzpjYS1cs=";
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
      ppx_string_conv
      ppx_tydi
      ppx_typerep_conv
      ppx_variants_conv
    ];
  };

  ppx_jsonaf_conv = janePackage {
    pname = "ppx_jsonaf_conv";
    hash = "sha256-v7CYOJ1g4LkqIv5De5tQjjkBWXqKHbvqfSr0X5jBUuM=";
    meta.description = "[@@deriving] plugin to generate Jsonaf conversion functions";
    propagatedBuildInputs = [
      base
      jsonaf
      ppx_jane
      ppxlib
    ];
    meta.broken = lib.versionAtLeast ppxlib.version "0.36";
  };

  ppx_js_style = janePackage (
    {
      pname = "ppx_js_style";
      meta.description = "Code style checker for Jane Street Packages";
      propagatedBuildInputs = [
        octavius
        ppxlib
      ];
    }
    // (
      if lib.versionAtLeast ppxlib.version "0.36" then
        {
          version = "0.17.1";
          hash = "sha256-YGGG468WVZbT5JfCB32FfTV7kdRz14ProDQxkdZuE44=";
        }
      else
        {
          version = "0.17.0";
          hash = "sha256-7jRzxe4bLyZ2vnHeqWiLlCUvOlNUAk0dwCfBFhrykUU=";
        }
    )
  );

  ppx_let = janePackage (
    {
      pname = "ppx_let";
      meta.description = "Monadic let-bindings";
      propagatedBuildInputs = [
        ppxlib
        ppx_here
      ];
    }
    // (
      if lib.versionAtLeast ppxlib.version "0.36" then
        {
          version = "0.17.1";
          hash = "sha256-41C60UcMpERZs2eAPprg63uPnmjj33n7cd5s5IFZBGE=";
        }
      else
        {
          version = "0.17.0";
          hash = "sha256-JkNQgbPHVDH659m4Xy9ipcZ/iqGtj5q1qQn1P+O7TUY=";
        }
    )
  );

  ppx_log = janePackage {
    pname = "ppx_log";
    hash = "sha256-llnjWeJH4eg5WtegILRxdwO3RWGWTFeCIKr6EbrUDI4=";
    meta.description = "Ppx_sexp_message-like extension nodes for lazily rendering log messages";
    propagatedBuildInputs = [
      base
      ppx_compare
      ppx_enumerate
      ppx_expect
      ppx_fields_conv
      ppx_here
      ppx_let
      ppx_sexp_conv
      ppx_sexp_message
      ppx_sexp_value
      ppx_string
      ppx_variants_conv
      sexplib
    ];
    doCheck = false; # test build rules broken
  };

  ppx_module_timer = janePackage {
    pname = "ppx_module_timer";
    hash = "sha256-OWo1Ij9JAxsk9HlTlaz9Qw2+4YCvXDmIvytAOgFCLPI=";
    meta.description = "Ppx rewriter that records top-level module startup times";
    propagatedBuildInputs = [ time_now ];
  };

  ppx_optcomp = janePackage (
    {
      pname = "ppx_optcomp";
      meta.description = "Optional compilation for OCaml";
      propagatedBuildInputs = [ ppxlib ];
    }
    // (
      if lib.versionAtLeast ppxlib.version "0.36" then
        {
          version = "0.17.1";
          hash = "sha256-mi9YM0WGkc4sI1GF2YGTFwmPdF+4s5Ou2l7i07ys9nw=";
        }
      else
        {
          version = "0.17.0";
          hash = "sha256-H9oTzhJx9IGRkcwY2YEvcvNgeJ8ETNO95qKcjTXJBwk=";
        }
    )
  );

  ppx_optional = janePackage {
    pname = "ppx_optional";
    hash = "sha256-SHw2zh6lG1N9zWF2b3VWeYzRHUx4jUxyOYgHd2/N9wE=";
    meta.description = "Pattern matching on flat options";
    propagatedBuildInputs = [
      ppxlib
      ppxlib_jane
    ];
  };

  ppx_pattern_bind = janePackage {
    pname = "ppx_pattern_bind";
    hash = "sha256-IVDvFU9ERB2YFJOgP/glYcO4KhEH5VdQ7wCCfreboqA=";
    meta.description = "PPX for writing fast incremental bind nodes in a pattern match";
    propagatedBuildInputs = [ ppx_let ];
    meta.broken = lib.versionAtLeast ppxlib.version "0.36";
  };

  ppx_pipebang = janePackage {
    pname = "ppx_pipebang";
    hash = "sha256-GBa1zzNChZOQfVSHyUeDEMFxuNUT3lj/pIQi/l1J35M=";
    meta.description = "PPX rewriter that inlines reverse application operators `|>` and `|!`";
    propagatedBuildInputs = [ ppxlib ];
  };

  ppx_python = janePackage {
    pname = "ppx_python";
    hash = "sha256-WqTYH5Zz/vRak/CL1ha8oUbQ8+XRuUu9610uj8II74o=";
    meta.description = "[@@deriving] plugin to generate Python conversion functions";
    propagatedBuildInputs = [
      ppx_base
      ppxlib
      pyml
    ];
    doCheck = false; # test rules broken
  };

  ppx_quick_test = janePackage {
    pname = "ppx_quick_test";
    hash = "sha256-Kxb0IJcosC4eYlUjEfZE9FhY8o1/gDHHLWD5Cby5hXY=";
    meta.description = "Spiritual equivalent of let%expect_test, but for property based tests";
    propagatedBuildInputs = [
      async
      async_kernel
      base
      base_quickcheck
      core
      core_kernel
      expect_test_helpers_core
      ppx_expect
      ppx_here
      ppx_jane
      ppx_sexp_conv
      ppx_sexp_message
    ];
    meta.broken = lib.versionAtLeast ppxlib.version "0.36";
  };

  ppx_sexp_conv = janePackage (
    {
      pname = "ppx_sexp_conv";
      meta.description = "[@@deriving] plugin to generate S-expression conversion functions";
      propagatedBuildInputs = [
        ppxlib
        ppxlib_jane
        sexplib0
        base
      ];
    }
    // (
      if lib.versionAtLeast ppxlib.version "0.36" then
        {
          version = "0.17.1";
          hash = "sha256-yQJluA/NSzCAID/ydBgRuc1sFHyjbXare9vxen6f1iw=";
        }
      else
        {
          version = "0.17.0";
          hash = "sha256-hUi0I50SODK1MpL86xy8eM8yn8f4q1Hv4LP9zFnnr70=";
        }
    )
  );

  ppx_sexp_message = janePackage {
    pname = "ppx_sexp_message";
    hash = "sha256-SNgTvsTUgFzjqHpyIYk4YuA4c5MbA9e77YUEsDaKTeA=";
    meta.description = "PPX rewriter for easy construction of s-expressions";
    propagatedBuildInputs = [
      ppx_here
      ppx_sexp_conv
    ];
  };

  ppx_sexp_value = janePackage {
    pname = "ppx_sexp_value";
    hash = "sha256-f96DLNFI+s3TKsOj01i6xUoM9L+qRgAXbbepNis397I=";
    meta.description = "PPX rewriter that simplifies building s-expressions from ocaml values";
    propagatedBuildInputs = [
      ppx_here
      ppx_sexp_conv
    ];
  };

  ppx_stable = janePackage (
    {
      pname = "ppx_stable";
      meta.description = "Stable types conversions generator";
      propagatedBuildInputs = [ ppxlib ];
    }
    // (
      if lib.versionAtLeast ppxlib.version "0.36" then
        {
          version = "0.17.1";
          hash = "sha256-iVAgRVSOdLzajuUT8Yz+YMiMeChIx5DT8lBf104QMuE=";
        }
      else
        {
          version = "0.17.0";
          hash = "sha256-N5oPjjQcLgiO9liX8Z0vg0IbQXaGZ4BqOgwvuIKSKaA=";
        }
    )
  );

  ppx_stable_witness = janePackage {
    pname = "ppx_stable_witness";
    hash = "sha256-k45uR/OMPRsi5450CuUo592EVc82DPhO8TvBPjgJTh0=";
    meta.description = "Ppx extension for deriving a witness that a type is intended to be stable";
    propagatedBuildInputs = [
      base
      ppxlib
    ];
  };

  ppx_string = janePackage {
    pname = "ppx_string";
    hash = "sha256-taAvJas9DvR5CIiFf38IMdNqLJ0QJmnIdcNJAaVILgA=";
    meta.description = "Ppx extension for string interpolation";
    propagatedBuildInputs = [
      ppx_base
      ppxlib
      stdio
    ];
  };

  ppx_string_conv = janePackage {
    pname = "ppx_string_conv";
    hash = "sha256-r+XubSXjxVyCsra99D6keJ/lmXeK5SZbI6h/IFghvPQ=";
    meta.description = "Ppx to help derive of_string and to_string, primarily for variant types";
    propagatedBuildInputs = [
      capitalization
      ppx_let
      ppx_string
    ];
  };

  ppx_tydi = janePackage (
    {
      pname = "ppx_tydi";
      meta.description = "Let expressions, inferring pattern type from expression";
      propagatedBuildInputs = [
        base
        ppxlib
      ];
    }
    // (
      if lib.versionAtLeast ppxlib.version "0.36" then
        {
          version = "0.17.1";
          hash = "sha256-dkZwu4Ujj7GKb4qo76f/ef5dvGrYSkk9B3y+Rg72CAM=";
        }
      else
        {
          version = "0.17.0";
          hash = "sha256-PM89fP6Rb6M99HgEzQ7LfpW1W5adw6J/E1LFQJtdd0U=";
        }
    )
  );

  ppx_typed_fields = janePackage {
    pname = "ppx_typed_fields";
    hash = "sha256-aTPEBBc1zniZkEmzubGkU064bwGnefBOjVDqTdPm2w8=";
    meta.description = "GADT-based field accessors and utilities";
    propagatedBuildInputs = [
      core
      ppx_jane
      ppxlib
    ];
    meta.broken = lib.versionAtLeast ppxlib.version "0.36";
  };

  ppx_typerep_conv = janePackage (
    {
      pname = "ppx_typerep_conv";
      meta.description = "Generation of runtime types from type declarations";
      propagatedBuildInputs = [
        ppxlib
        typerep
      ];
    }
    // (
      if lib.versionAtLeast ppxlib.version "0.36" then
        {
          version = "0.17.1";
          hash = "sha256-rxqL2v5vqjc7MgKUSkJEyIhm9GO5YqvxEYSM/uXdeBc=";
        }
      else
        {
          version = "0.17.0";
          hash = "sha256-V9yOSy3cj5/bz9PvpO3J+aeFu1G+qGQ8AR3gSczUZbY=";
        }
    )
  );

  ppx_variants_conv = janePackage (
    {
      pname = "ppx_variants_conv";
      meta.description = "Generation of accessor and iteration functions for ocaml variant types";
      propagatedBuildInputs = [
        variantslib
        ppxlib
      ];
    }
    // (
      if lib.versionAtLeast ppxlib.version "0.36" then
        {
          version = "0.17.1";
          hash = "sha256-4v9sXtu7rDM+W3phPloizeMczRbBhku5dsCG4NqhdfU=";
        }
      else
        {
          version = "0.17.0";
          hash = "sha256-Av2F699LzVCpwcdji6qG0jt5DVxCnIY4eBLaPK1JC10=";
        }
    )
  );

  ppxlib_jane = janePackage (
    {
      pname = "ppxlib_jane";
      meta.description = "Library for use in ppxes for constructing and matching on ASTs corresponding to the augmented parsetree";
      propagatedBuildInputs = [ ppxlib ];
    }
    // (
      if lib.versionAtLeast ppxlib.version "0.36" then
        {
          version = "0.17.4";
          hash = "sha256-cqF7aT0ubutRxsSTD5aHnHx4zvlPDkTzdBqONU6EgO0=";
        }
      else if lib.versionAtLeast ocaml.version "5.3" then
        {
          version = "0.17.2";
          hash = "sha256-AQJSdKtF6p/aG5Lx8VHVEOsisH8ep+iiml6DtW+Hdik=";
        }
      else
        {
          version = "0.17.0";
          hash = "sha256-8NC8CHh3pSdFuRDQCuuhc2xxU+84UAsGFJbbJoKwd0U=";
        }
    )
  );

  profunctor = janePackage {
    pname = "profunctor";
    hash = "sha256-WYPJLt3kYvIzh88XcPpw2xvSNjNX63/LvWwIDK+Xr0Q=";
    meta.description = "Library providing a signature for simple profunctors and traversal of a record";
    propagatedBuildInputs = [
      base
      ppx_jane
      record_builder
    ];
  };

  protocol_version_header = janePackage {
    pname = "protocol_version_header";
    hash = "sha256-WKy4vahmmj6o82/FbzvFYfJFglgNMrka0XhtCMUyct4=";
    meta.description = "Protocol versioning";
    propagatedBuildInputs = [ core_kernel ];
  };

  re2 = janePackage {
    pname = "re2";
    hash = "sha256-0VCSOzrVouMRVZJumcqv0F+HQFXlFfVEFIhYq7Tfhrg=";
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
    hash = "sha256-NQ0Wizxi/wD8BCwt8hxZWnEpLBTn3XkaG+96ooOKIFE=";
    meta.description = "Library which provides traversal of records with an applicative";
    propagatedBuildInputs = [
      base
      ppx_jane
    ];
  };

  redis-async = janePackage {
    pname = "redis-async";
    hash = "sha256-bwKPEnK2uJq5H65BDAL1Vk3qSr5kUwaCEiFsgaCdHw8=";
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
    hash = "sha256-j6zWJf5c5qWphMqb9JpEAMGDDsrzV+NU2zrGmZHSAgk=";
    meta.description = "Interface shared by Re_parser and Re2.Parser";
    propagatedBuildInputs = [ base ];
  };

  resource_cache = janePackage {
    pname = "resource_cache";
    hash = "sha256-1WEjvdnl47rjCCMvGxqDKAb2ny6pJDlvDfZhKp+40Jg=";
    meta.description = "General resource cache";
    propagatedBuildInputs = [ async_rpc_kernel ];
  };

  semantic_version = janePackage {
    pname = "semantic_version";
    hash = "sha256-2Z2C+1bfI6W7Pw7SRYw8EkaVVwQkkm+knCrJIfsJhPE=";
    meta.description = "Semantic versioning";
    propagatedBuildInputs = [
      core
      ppx_jane
      re
    ];
  };

  sexp = janePackage {
    pname = "sexp";
    hash = "sha256-89SNb0MeJbetRRbA5qbBQPXIcLQ0QCeSf8p9v5yUTP0=";
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
    hash = "sha256-yagp8bEZvc4joV81w56hAb17mUbnekuzECVcwLIvYoE=";
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
    hash = "sha256-0p1+jMa2b/GJu+JtN+XUuR04lFQchxMeu9ikfgErqMU=";
    propagatedBuildInputs = [ core_kernel ];
    meta.description = "Code for computing the diff of two sexps";
  };

  sexp_macro = janePackage {
    pname = "sexp_macro";
    hash = "sha256-KXJ+6uR38ywkr8uT8n2bWk10W7vW2ntMgxgF4ZvzzWU=";
    propagatedBuildInputs = [
      async
      sexplib
    ];
    meta.description = "Sexp macros";
  };

  sexp_pretty = janePackage {
    pname = "sexp_pretty";
    hash = "sha256-DcgLlwp3AMC1QzFYPzi7aHA+VhnhbG6p/fLDTMx8ATc=";
    meta.description = "S-expression pretty-printer";
    propagatedBuildInputs = [
      ppx_base
      re
      sexplib
    ];
  };

  sexp_select = janePackage {
    pname = "sexp_select";
    hash = "sha256-3AUFRtNe32TEB7lItcu7XlEv+3k+4QTitcTnT0kg28Y=";
    propagatedBuildInputs = [
      base
      core_kernel
      ppx_jane
    ];
    meta.description = "Library to use CSS-style selectors to traverse sexp trees";
  };

  sexplib0 = janePackage {
    pname = "sexplib0";
    hash = "sha256-Q53wEhRet/Ou9Kr0TZNTyXT5ASQpsVLPz5n/I+Fhy+g=";
    minimalOCamlVersion = "4.14.0";
    meta.description = "Library containing the definition of S-expressions and some base converters";
  };

  sexplib = janePackage {
    pname = "sexplib";
    hash = "sha256-DxTMAQbskZ87pMVQnxYc3opGGCzmUKGCZfszr/Z9TGA=";
    meta.description = "Library for serializing OCaml values to and from S-expressions";
    propagatedBuildInputs = [
      num
      parsexp
    ];
  };

  shell = janePackage {
    pname = "shell";
    hash = "sha256-MJerTFLGrUaR3y3mnKVrH5EQHYBXZyuVL+n2wJZ9HoU=";
    meta.description = "Yet another implementation of fork&exec and related functionality";
    buildInputs = [ jst-config ];
    propagatedBuildInputs = [ textutils ];
    checkInputs = [ ounit ];
  };

  shexp = janePackage {
    pname = "shexp";
    hash = "sha256-tf9HqZ01gMWxfcpe3Pl3rdPTPgIEdb59iwzwThznqAc=";
    propagatedBuildInputs = [
      posixat
      spawn
    ];
    meta.description = "Process library and s-expression based shell";
  };

  spawn = janePackage {
    pname = "spawn";
    minimalOCamlVersion = "4.05";
    version = "0.15.1";
    hash = "sha256-6vAkRjTZQGiPhYBWX4MBO3GxEDmAE+18vpMWXMcvWJk=";
    meta.description = "Spawning sub-processes";
    buildInputs = [ ppx_expect ];
  };

  splay_tree = janePackage {
    pname = "splay_tree";
    hash = "sha256-gRHRqUKjFEgkL1h8zSbqJkf+gHxhh61AtAT+mkPcz+k=";
    meta.description = "Splay tree implementation";
    propagatedBuildInputs = [ core_kernel ];
  };

  splittable_random = janePackage {
    pname = "splittable_random";
    hash = "sha256-LlaCxL17GBZc33spn/JnunpaMQ47n+RXS8CShBlaRWA=";
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
    hash = "sha256-N4VMUq6zWdYiJarVECSadxnoXJKh6AsIIaChmHFSbdA=";
    meta.description = "Standard IO library for OCaml";
    propagatedBuildInputs = [ base ];
  };

  stored_reversed = janePackage {
    pname = "stored_reversed";
    hash = "sha256-FPyQxXaGAzFWW6GiiqKQgU+6/lAZhEQwhNnXsmqKkzg=";
    meta.description = "Library for representing a list temporarily stored in reverse order";
    propagatedBuildInputs = [
      core
      ppx_jane
    ];
  };

  streamable = janePackage {
    pname = "streamable";
    hash = "sha256-FtrAX4nsacCO5HTVxwLgwwT8R2sASJ05qu4gT2ZVSDg=";
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
    meta.broken = lib.versionAtLeast ppxlib.version "0.36";
  };

  textutils = janePackage {
    pname = "textutils";
    hash = "sha256-J58sqp9fkx3JyjnH6oJLCyEC0ZvnuDfqLVl+dt3tEgA=";
    meta.description = "Text output utilities";
    propagatedBuildInputs = [
      core_unix
      textutils_kernel
    ];
  };

  textutils_kernel = janePackage {
    pname = "textutils_kernel";
    hash = "sha256-B5ExbKMRSw4RVJ908FVGob2soHFnJ6Ajsdn0q8lDhio=";
    meta.description = "Text output utilities";
    propagatedBuildInputs = [
      core
      ppx_jane
      uutf
    ];
  };

  tilde_f = janePackage {
    pname = "tilde_f";
    hash = "sha256-tuddvOmhk0fikB4dHNdXamBx6xfo4DCvivs44QXp5RQ=";
    meta.description = "Provides a let-syntax for continuation-passing style";
    propagatedBuildInputs = [
      base
      ppx_jane
    ];
  };

  time_now = janePackage {
    pname = "time_now";
    hash = "sha256-bTPWE9+x+zmdLdzLc1naDlRErPZ8m4WXDJL2iLErdqk=";
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
    hash = "sha256-/6OLWMrkyQSVTNJ24zRy6v4DObt9q99s75QRS/VVxXE=";
    meta.description = "Time-zone handling";
    propagatedBuildInputs = [ core_kernel ];
  };

  topological_sort = janePackage {
    pname = "topological_sort";
    hash = "sha256-jLkJnh5lasrphI6BUKv7oVPrKyGqNm6VIGYthNs04iU=";
    meta.description = "Topological sort algorithm";
    propagatedBuildInputs = [
      ppx_jane
      stdio
    ];
  };

  typerep = janePackage {
    pname = "typerep";
    version = "0.17.1";
    hash = "sha256-hw03erwLx9IAbkBibyhZxofA5jIi12rFJOHNEVYpLSk=";
    meta.description = "Typerep is a library for runtime types";
    propagatedBuildInputs = [ base ];
  };

  uopt = janePackage {
    pname = "uopt";
    hash = "sha256-t0SFJVF0ScyFFwziBZOYCOsmhRd6J5H3s0Kk9NKorcM=";
    meta.description = "[option]-like type that incurs no allocation";
    propagatedBuildInputs = [
      base
      ppx_jane
    ];
  };

  username_kernel = janePackage {
    pname = "username_kernel";
    hash = "sha256-1lxWSv7CbmucurNw8ws18N9DYqo4ik2KZBc5GtNmmeU=";
    meta.description = "Identifier for a user";
    propagatedBuildInputs = [
      core
      ppx_jane
    ];
  };

  variantslib = janePackage {
    pname = "variantslib";
    hash = "sha256-v/p718POQlFsB7N7WmMCDnmQDB2sP1263pSQIuvlLt8=";
    meta.description = "Part of Jane Street's Core library";
    propagatedBuildInputs = [ base ];
  };

  vcaml = janePackage {
    pname = "vcaml";
    hash = "sha256-z3v0Uqb+jE19+EN/b6qQvAx+FaK5HmbdHnxEkYGSmS8=";
    meta.description = "OCaml bindings for the Neovim API";
    propagatedBuildInputs = [
      angstrom-async
      async_extra
      base_trie
      expect_test_helpers_async
      faraday
      jsonaf
      man_in_the_middle_debugger
      semantic_version
    ];
    doCheck = false; # tests depend on nvim
  };

  versioned_polling_state_rpc = janePackage {
    pname = "versioned_polling_state_rpc";
    hash = "sha256-Ba+Pevc/cvvY9FnQ2oTUxTekxypVkEy4MfrpRKmJhZ0=";
    meta.description = "Helper functions for creating stable/versioned `Polling_state_rpc.t`s with babel";
    propagatedBuildInputs = [
      async_rpc_kernel
      babel
      core
      polling_state_rpc
      ppx_jane
    ];
  };

  virtual_dom = janePackage {
    pname = "virtual_dom";
    hash = "sha256-5T+/N1fELa1cR9mhWLUgS3Fwr1OQXJ3J6T3YaHT9q7U=";
    meta.description = "OCaml bindings for the virtual-dom library";
    meta.broken = lib.versionAtLeast ocaml.version "5.3";
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

  virtual_dom_toplayer = janePackage {
    pname = "virtual_dom_toplayer";
    hash = "sha256-trTSWzWsXkV4RtQvVCyXqJN5/wftaFuooaehNekP9H0=";
    meta.description = "OCaml bindings for the floating positioning library for 'toplevel' virtual dom components";
    propagatedBuildInputs = [
      core
      js_of_ocaml_patches
      ppx_css
      ppx_jane
      virtual_dom
      gen_js_api
      js_of_ocaml
      js_of_ocaml-ppx
    ];
  };

  zarith_stubs_js = janePackage {
    pname = "zarith_stubs_js";
    hash = "sha256-QNhs9rHZetwgKAOftgQQa6aU8cOux8JOe3dBRrLJVh0=";
    meta.description = "Javascripts stubs for the Zarith library";
    propagatedBuildInputs = [ ppx_jane ];
    doCheck = false; # some test sources unavailable
  };

  zstandard = janePackage {
    pname = "zstandard";
    hash = "sha256-EUI7fnN8ZaM1l0RBsgSAMWO+VXA8VoCv/lO5kcj+j4E=";
    meta.description = "OCaml bindings to Zstandard";
    buildInputs = [ ppx_jane ];
    propagatedBuildInputs = [
      core_kernel
      ctypes
      zstd
    ];
  };
}
