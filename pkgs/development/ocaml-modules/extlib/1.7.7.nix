# Older version of extlib for Haxe 4.0 and 4.1.
# May be replaceable by the next extlib + extlib-base64 release.
{ stdenv, lib, fetchurl, ocaml, findlib, cppo
# De facto, option minimal seems to be the default. See the README.
, minimal ? true
}:

stdenv.mkDerivation rec {
  pname = "ocaml${ocaml.version}-extlib";
  version = "1.7.7";

  src = fetchurl {
    url = "https://ygrek.org/p/release/ocaml-extlib/extlib-${version}.tar.gz";
    sha256 = "1sxmzc1mx3kg62j8kbk0dxkx8mkf1rn70h542cjzrziflznap0s1";
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
    broken = lib.versionAtLeast ocaml.version "4.12";
  };
}
