{ stdenv, fetchFromGitHub, ocaml, findlib, ocamlbuild, ocaml_oasis }:

stdenv.mkDerivation rec {
  pname = "parmap";
  version = "1.0-rc11";

  owner = "rdicosmo";

  src = fetchFromGitHub {
    inherit owner;
    repo   = pname;
    rev    = version;
    sha256 = "149i1sz9xr59707sfa75b94pjahk3v8ky7rfmdhzmj2myjwy1vy8";
  };

  buildInputs = [ ocaml findlib ocamlbuild ocaml_oasis ];

  meta = with stdenv.lib; {
    description = "Library for multicore parallel programming";
    homepage = "http://${owner}.github.io/${pname}";
    maintainers = [ maintainers.bcdarwin ];
    license = licenses.gpl2;
  };
}
