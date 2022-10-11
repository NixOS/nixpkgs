{ stdenv, lib, fetchzip, ocaml, findlib, ocamlbuild }:

lib.throwIfNot (lib.versionAtLeast ocaml.version "4.02")
  "semver is not available on OCaml older than 4.02"

stdenv.mkDerivation rec {
  pname = "ocaml${ocaml.version}-semver";
  version = "0.1.0";
  src = fetchzip {
    url = "https://github.com/rgrinberg/ocaml-semver/archive/v${version}.tar.gz";
    sha256 = "sha256-0BzeuVTpuRIQjadGg08hTvMzZtKCl2utW2YK269oETk=";
  };

  nativeBuildInputs = [
    ocaml
    findlib
    ocamlbuild
  ];

  strictDeps = true;
  createFindlibDestdir = true;

  meta = {
    homepage = "https://github.com/rgrinberg/ocaml-semver";
    description = "Semantic versioning module";
    platforms = ocaml.meta.platforms;
    license = lib.licenses.bsd3;
    maintainers = [ lib.maintainers.ulrikstrid ];
  };
}
