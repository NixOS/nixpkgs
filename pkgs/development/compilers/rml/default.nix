{
  lib,
  stdenv,
  fetchFromGitHub,
  ocamlPackages,
}:

stdenv.mkDerivation rec {
  pname = "rml";
  version = "1.09.07";

  src = fetchFromGitHub {
    owner = "reactiveml";
    repo = "rml";
    rev = "rml-${version}-2021-07-26";
    hash = "sha256-UFqXQBeIQMSV4O439j9s06p1hh7xA98Tu79FsjK9PIY=";
  };

  strictDeps = true;

  nativeBuildInputs = with ocamlPackages; [
    ocaml
  ];

  buildInputs = with ocamlPackages; [
    num
  ];

  prefixKey = "-prefix ";

  meta = with lib; {
    description = "ReactiveML: a programming language for implementing interactive systems";
    homepage = "https://rml.lri.fr";
    license = with licenses; [
      qpl
      lgpl21Plus
    ];
    maintainers = with maintainers; [ wegank ];
  };
}
