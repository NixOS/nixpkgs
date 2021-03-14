{ stdenv, lib, fetchurl, ocaml, findlib, cppo, minimal ? true }:

assert lib.versionAtLeast (lib.getVersion ocaml) "3.11";

stdenv.mkDerivation rec {
  pname = "ocaml${ocaml.version}-extlib";
  version = "1.7.8";

 src = fetchurl {
    url = "https://ygrek.org/p/release/ocaml-extlib/extlib-${version}.tar.gz";
    sha256 = "0npq4hq3zym8nmlyji7l5cqk6drx2rkcx73d60rxqh5g8dla8p4k";
  };

  buildInputs = [ ocaml findlib cppo ];

  createFindlibDestdir = true;

  dontConfigure = true;      # Skip configure
  # De facto, option minimal=1 seems to be the default.  See the README.
  buildPhase     = "make ${if minimal then "minimal=1" else ""} build";
  installPhase   = "make ${if minimal then "minimal=1" else ""} install";

  meta = {
    homepage = "https://github.com/ygrek/ocaml-extlib";
    description = "Enhancements to the OCaml Standard Library modules";
    license = lib.licenses.lgpl21;
    platforms = ocaml.meta.platforms or [];
  };
}
