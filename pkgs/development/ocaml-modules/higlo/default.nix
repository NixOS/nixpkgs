{ stdenv, fetchFromGitHub, ocaml, findlib, xtmpl, ulex }:

stdenv.mkDerivation rec {
  name = "higlo-${version}";
  version = "0.6";
  src = fetchFromGitHub {
    owner = "zoggy";
    repo = "higlo";
    rev = "release-${version}";
    sha256 = "0m0qyk2ydivai54502s45sdw9w4xr0j3jpwyc4vqk62a7iz9ihxh";
  };

  buildInputs = [ ocaml findlib ];
  propagatedBuildInputs = [ xtmpl ulex ];

  createFindlibDestdir = true;

  patches = ./install.patch;

  meta = with stdenv.lib; {
    description = "OCaml library for syntax highlighting";
    homepage = "https://zoggy.github.io/higlo/";
    license = licenses.lgpl3;
    platforms = ocaml.meta.platforms or [];
    maintainers = with maintainers; [ regnat ];
  };
}


