{stdenv, fetchurl, ocaml, findlib}:

stdenv.mkDerivation {
  name = "ocaml-calendar-2.5";
  src = fetchurl {
    url = https://forge.ocamlcore.org/frs/download.php/915/calendar-2.5.tar.bz2;
    sha256 = "04pvhwb664g3s644c7v7419a3kvf5s3pynkhmk5j59dvlfm1yf0f";
    };

  buildInputs = [ocaml findlib];

  createFindlibDestdir = true;

  meta =  {
    homepage = https://forge.ocamlcore.org/projects/calendar/;
    description = "An Objective Caml library managing dates and times";
    license = "LGPL";
    platforms = ocaml.meta.platforms or [];
    maintainers = [
      stdenv.lib.maintainers.gal_bolle
    ];
  };
}
