{ stdenv, lib, fetchurl, ocaml, findlib, cppo
# De facto, option minimal seems to be the default. See the README.
, minimal ? true
}:

stdenv.mkDerivation rec {
  pname = "ocaml${ocaml.version}-extlib";
  version = "1.7.9";

  src = fetchurl {
    url = "https://ygrek.org/p/release/ocaml-extlib/extlib-${version}.tar.gz";
    sha256 = "sha256-WN5N3gFt6wC08zlWq5aXKC9OYHxkUuPTj44RZAX/zcs=";
  };

  nativeBuildInputs = [ ocaml findlib cppo ];

  strictDeps = true;

  createFindlibDestdir = true;

  makeFlags = lib.optional minimal "minimal=1";

  meta = {
    homepage = "https://github.com/ygrek/ocaml-extlib";
    description = "Enhancements to the OCaml Standard Library modules";
    license = lib.licenses.lgpl21Only;
    inherit (ocaml.meta) platforms;
    maintainers = [ lib.maintainers.sternenseemann ];
  };
}
