{ stdenv, lib, fetchurl, ocaml, findlib, cppo
# De facto, option minimal seems to be the default. See the README.
, minimal ? true
}:

stdenv.mkDerivation rec {
  pname = "ocaml${ocaml.version}-extlib";
  version = "1.7.8";

  src = fetchurl {
    url = "https://ygrek.org/p/release/ocaml-extlib/extlib-${version}.tar.gz";
    sha256 = "0npq4hq3zym8nmlyji7l5cqk6drx2rkcx73d60rxqh5g8dla8p4k";
  };

  nativeBuildInputs = [ ocaml findlib cppo ];

  strictDeps = true;

  createFindlibDestdir = true;

  makeFlags = lib.optional minimal "minimal=1";

  meta = {
    homepage = "https://github.com/ygrek/ocaml-extlib";
    description = "Enhancements to the OCaml Standard Library modules";
    license = lib.licenses.lgpl21Only;
    platforms = ocaml.meta.platforms or [];
    maintainers = [ lib.maintainers.sternenseemann ];
  };
}
