{ stdenv, fetchurl, fetchpatch, ocaml, findlib, ocamlbuild, topkg
, cpuid, ocb-stubblr, sexplib
, cstruct, zarith, ppx_sexp_conv, ppx_deriving, writeScriptBin
, cstruct-lwt ? null
}:

with stdenv.lib;
let
  withLwt = cstruct-lwt != null;
  # the build system will call 'cc' with no way to override
  # this is wrong when we're cross-compiling, so insert a wrapper
  cc-wrapper = writeScriptBin "cc" ''
    set -e
    $CC "$@"
  '';
in

stdenv.mkDerivation rec {
  name = "ocaml${ocaml.version}-nocrypto-${version}";
  version = "0.5.4";

  src = fetchurl {
    url = "https://github.com/mirleft/ocaml-nocrypto/releases/download/v${version}/nocrypto-${version}.tbz";
    sha256 = "0zshi9hlhcz61n5z1k6fx6rsi0pl4xgahsyl2jp0crqkaf3hqwlg";
  };

  patches = [
    (fetchpatch {
      url = "https://raw.githubusercontent.com/ocaml/opam-repository/master/packages/nocrypto/nocrypto.0.5.4-1/files/0001-add-missing-runtime-dependencies-in-_tags.patch";
      sha256 = "1asybwj3rl07b4q4cxwy80a7j17j0i5vzz77p38hymilhc2ky7xn";
    })
    (fetchpatch {
      url = "https://raw.githubusercontent.com/ocaml/opam-repository/master/packages/nocrypto/nocrypto.0.5.4-1/files/0002-add-ppx_sexp_conv-as-a-runtime-dependency-in-the-pac.patch";
      sha256 = "0zmp64n5fgkawpkyw0vv0bg0i2c3xbsxqy17vwy92nf5rbardi1r";
    })
    (fetchpatch {
      url = "https://raw.githubusercontent.com/ocaml/opam-repository/master/packages/nocrypto/nocrypto.0.5.4-1/files/0003-Auto-detect-ppx_sexp_conv-runtime-library.patch";
      sha256 = "0lngbg5gyd5gs56lbjh6g86cps1y8x1xsqzi0vi1v28al1gn5dhw";
    })
    (fetchpatch {
      url = "https://raw.githubusercontent.com/ocaml/opam-repository/master/packages/nocrypto/nocrypto.0.5.4-1/files/0004-pack-package-workaround-ocamlbuild-272.patch";
      sha256 = "16k0w78plvqhl17qiqq1mckxhhcdysqgs94l54a1bn0l6fx3rvb9";
    })
    (fetchpatch {
      url = "https://raw.githubusercontent.com/ocaml/opam-repository/master/packages/nocrypto/nocrypto.0.5.4-1/files/0005-use-modern-cstruct-findlib.patch";
      sha256 = "021k38zbdidw6g7j4vjxlnbsrnzq07bnavxzdjq23nbwlifs2nq9";
    })
    (fetchpatch {
      url = "https://raw.githubusercontent.com/ocaml/opam-repository/master/packages/nocrypto/nocrypto.0.5.4-1/files/0006-explicit-dependency-on-sexplib.patch";
      sha256 = "15kd0qgi96yxr3qkmaqny591l0s6qmwpprxd5xdx9qwv72hq813z";
    })
  ];

  nativeBuildInputs = [ ocaml findlib ocamlbuild cc-wrapper ];
  buildInputs = [ ocamlbuild findlib topkg cpuid ocb-stubblr ];
  propagatedBuildInputs = [ cstruct ppx_deriving ppx_sexp_conv sexplib zarith ] ++ optional withLwt cstruct-lwt;

  buildPhase = "${topkg.buildPhase} --with-lwt ${boolToString withLwt}";
  inherit (topkg) installPhase;

  meta = {
    homepage = https://github.com/mirleft/ocaml-nocrypto;
    description = "Simplest possible crypto to support TLS";
    license = stdenv.lib.licenses.bsd2;
    maintainers = with stdenv.lib.maintainers; [ vbgl ];
  };
}
