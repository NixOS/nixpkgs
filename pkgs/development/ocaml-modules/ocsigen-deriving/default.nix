{stdenv, fetchgit, ocaml, findlib, ocaml_oasis, ocaml_data_notation, ocaml_optcomp}:

stdenv.mkDerivation {
  name = "ocsigen-deriving";
  src = fetchgit {
    url = "git://github.com/ocsigen/deriving";
    rev = "refs/tags/0.6.2";
    sha256 = "2b3bf3f4972d0e6eaf075f7353ce482b776726e0cd04947a89b7156384ec0662";
    };

  buildInputs = [ocaml findlib ocaml_oasis ocaml_data_notation ocaml_optcomp];

  configurePhase = ''
  make setup-dev.exe
  ./setup-dev.exe -configure --prefix $out
  '';

  createFindlibDestdir = true;


  meta =  {
    homepage = https://github.com/ocsigen/deriving;
    description = "Extension to OCaml for deriving functions from type declarations";
    license = stdenv.lib.licenses.mit;
    platforms = ocaml.meta.platforms;
    maintainers = [
      stdenv.lib.maintainers.gal_bolle
    ];
  };


}
