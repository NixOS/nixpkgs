{ stdenv, fetchFromGitHub, ocaml, jbuilder, findlib }:

{ name, version ? "0.9.0", buildInputs ? [], hash, meta, ...}@args:

if !stdenv.lib.versionAtLeast ocaml.version "4.03"
then throw "${name}-${version} is not available for OCaml ${ocaml.version}" else

stdenv.mkDerivation (args // {
  name = "ocaml${ocaml.version}-${name}-${version}";
  inherit version;

  src = fetchFromGitHub {
    owner = "janestreet";
    repo = name;
    rev = "v${version}";
    sha256 = hash;
  };

  buildInputs = [ ocaml jbuilder findlib ] ++ buildInputs;

  inherit (jbuilder) installPhase;

  meta = {
    license = stdenv.lib.licenses.asl20;
    inherit (ocaml.meta) platforms;
    homepage = "https://github.com/janestreet/${name}";
  } // meta;
})
