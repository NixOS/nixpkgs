{stdenv, fetchurl, ocaml_pcre, ocamlnet, ocaml, findlib, camlp4}:

stdenv.mkDerivation {
  name = "ocaml-http-0.1.5";

  src = fetchurl {
    url = https://forge.ocamlcore.org/frs/download.php/545/ocaml-http-0.1.5.tar.gz;
    sha256 = "09q12b0j01iymflssxigsqggbsp8dqh9pfvkm76dv860544mygws";
  };

  buildInputs = [ocaml findlib camlp4];
  propagatedBuildInputs = [ocaml_pcre ocamlnet];

  createFindlibDestdir = true;

  prePatch = ''
    BASH=$(type -tp bash)
    echo $BASH
    substituteInPlace Makefile --replace "SHELL=/bin/bash" "SHELL=$BASH"
  '';

  configurePhase = "true";	# Skip configure phase

  buildPhase = ''
    make all opt
  '';

  meta = with stdenv.lib; {
    homepage = http://ocaml-http.forge.ocamlcore.org/;
    platforms = ocaml.meta.platforms;
    hydraPlatforms = ocaml.meta.hydraPlatforms;
    description = "do it yourself (OCaml) HTTP daemon";
    license = licenses.lgpl2;
    maintainers = with maintainers; [ roconnor vbgl ];
  };
}
