{ stdenv, lib, fetchurl, ocaml, findlib }:

stdenv.mkDerivation rec {
  pname = "ocaml-calendar";
  version = "2.5";

  src = fetchurl {
    url = "https://forge.ocamlcore.org/frs/download.php/915/calendar-${version}.tar.bz2";
    sha256 = "04pvhwb664g3s644c7v7419a3kvf5s3pynkhmk5j59dvlfm1yf0f";
  };

  nativeBuildInputs = [ ocaml findlib ];

  strictDeps = true;

  createFindlibDestdir = true;

  meta = {
    homepage = "https://forge.ocamlcore.org/projects/calendar/";
    description = "An Objective Caml library managing dates and times";
    license = "LGPL";
    platforms = ocaml.meta.platforms or [ ];
    maintainers = [
      lib.maintainers.gal_bolle
    ];
  };
}
