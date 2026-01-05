{
  lib,
  stdenv,
  fetchFromGitHub,
  ocaml,
  findlib,
  which,
  file,
}:

stdenv.mkDerivation rec {
  pname = "magic";
  version = "0.7.4";

  src = fetchFromGitHub {
    owner = "Chris00";
    repo = "ocaml-magic";
    tag = "v${version}";
    sha256 = "sha256-rsBMx68UDqmVVsyeZCxIS97A/0JCBM/JOgh60ly1uSs=";
  };

  createFindlibDestdir = true;

  nativeBuildInputs = [ which ];
  buildInputs = [
    ocaml
    findlib
  ];
  propagatedBuildInputs = [ file ];

  meta = with lib; {
    homepage = "https://github.com/Chris00/ocaml-magic";
    description = "Bindings for libmagic";
    license = licenses.lgpl21Plus;
    maintainers = [ ];
  };
}
