{ stdenv, lib, fetchurl, fetchpatch, ocaml, findlib, ocamlbuild, topkg
, cpuid, ocb-stubblr, sexplib
, cstruct, zarith, ppx_sexp_conv, ppx_deriving, writeScriptBin
, cstruct-lwt ? null
}:

with lib;
let
  withLwt = cstruct-lwt != null;
  # the build system will call 'cc' with no way to override
  # this is wrong when we're cross-compiling, so insert a wrapper
  cc-wrapper = writeScriptBin "cc" ''
    set -e
    $CC "$@"
  '';
in

if versionOlder ocaml.version "4.08"
then throw "nocrypto is not available for OCaml ${ocaml.version}"
else

stdenv.mkDerivation rec {
  pname = "ocaml${ocaml.version}-nocrypto";
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

  # cstruct >= 6.0.0 compat
  postPatch = ''
    substituteInPlace src/uncommon.ml \
      --replace ' len cs ' ' Cstruct.length cs ' \
      --replace 'let n1 = len cs1 and n2 = len cs2 in' 'let n1 = Cstruct.length cs1 and n2 = Cstruct.length cs2 in' \
      --replace 'let l1 = len cs1 and l2 = len cs2 in' 'let l1 = Cstruct.length cs1 and l2 = Cstruct.length cs2 in' \
      --replace 'None off (len cs - off)' 'None off (Cstruct.length cs - off)' \
      --replace '(len src) (len dst)' '(Cstruct.length src) (Cstruct.length dst)' \
      --replace '(len cs1) (len cs2)' '(Cstruct.length cs1) (Cstruct.length cs2)' \
      --replace '(len cs -' '(Cstruct.length cs -'

    substituteInPlace src/base64.ml \
      --replace ' len cs ' ' Cstruct.length cs '

    substituteInPlace src/hash.ml \
      --replace 'Cstruct.len' 'Cstruct.length'

    substituteInPlace src/cipher_stream.ml \
      --replace 'Cstruct.len' 'Cstruct.length'

    substituteInPlace src/numeric.ml \
      --replace 'Cstruct.len' 'Cstruct.length' \
      --replace '(len cs -' '(Cstruct.length cs -'

    substituteInPlace src/ccm.ml \
      --replace 'Cstruct.len' 'Cstruct.length'

    substituteInPlace src/gcm.ml \
      --replace ' len cs ' ' Cstruct.length cs ' \
      --replace ' len iv ' ' Cstruct.length iv ' \
      --replace '(len cs' '(Cstruct.length cs'

    substituteInPlace src/cipher_block.ml \
      --replace ' len cs ' ' Cstruct.length cs ' \
      --replace ' len src ' ' Cstruct.length src ' \
      --replace ' len iv ' ' Cstruct.length iv ' \
      --replace '(len cs -' '(Cstruct.length cs -' \
      --replace '(len msg' '(Cstruct.length msg' \
      --replace '(len src' '(Cstruct.length src'

    substituteInPlace src/fortuna.ml \
      --replace 'Cstruct.len' 'Cstruct.length'

    substituteInPlace src/rng.ml \
      --replace ' Cstruct.len' ' Cstruct.length'

    substituteInPlace src/rsa.ml \
      --replace ' len msg' ' Cstruct.length msg' \
      --replace ' len em' ' Cstruct.length em' \
      --replace '(len db' '(Cstruct.length db' \
      --replace '(len cs' '(Cstruct.length cs' \
      --replace 'len signature' 'Cstruct.length signature'

    substituteInPlace src/dsa.ml \
      --replace ' Cstruct.len' ' Cstruct.length'

    substituteInPlace unix/nocrypto_entropy_unix.ml \
      --replace ' Cstruct.len' ' Cstruct.length'
  '';

  nativeBuildInputs = [ ocaml findlib ocamlbuild cc-wrapper ];
  buildInputs = [ topkg cpuid ocb-stubblr ocamlbuild ];
  propagatedBuildInputs = [ cstruct ppx_deriving ppx_sexp_conv sexplib zarith ] ++ optional withLwt cstruct-lwt;

  strictDeps = true;

  buildPhase = "${topkg.buildPhase} --accelerate false --with-lwt ${boolToString withLwt}";
  inherit (topkg) installPhase;

  meta = {
    homepage = "https://github.com/mirleft/ocaml-nocrypto";
    description = "Simplest possible crypto to support TLS";
    license = lib.licenses.bsd2;
    maintainers = with lib.maintainers; [ vbgl ];
  };
}
