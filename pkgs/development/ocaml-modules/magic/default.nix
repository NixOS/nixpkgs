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
  version = "0.7.3";

  src = fetchFromGitHub {
    owner = "Chris00";
    repo = "ocaml-magic";
    rev = "510c473d222a3d3d900b8ae1892d13e0d49d08be"; # no tags in repo
    sha256 = "0qks3v51xvzxhidai414mbszxhcl8wg8g7zxd04qi260433g77yg";
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
    maintainers = with maintainers; [ dandellion ];
  };
}
