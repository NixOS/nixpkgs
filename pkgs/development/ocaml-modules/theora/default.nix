{
  lib,
  buildDunePackage,
  fetchFromGitHub,
  dune-configurator,
  ogg,
  libtheora,
}:

buildDunePackage rec {
  pname = "theora";
  version = "0.4.1";

  duneVersion = "3";

  src = fetchFromGitHub {
    owner = "savonet";
    repo = "ocaml-theora";
    rev = "v${version}";
    hash = "sha256-2FXB5BOBRQhnpEmdlYBdZZXuXW9K+1cu7akJQDuDAMc=";
  };

  buildInputs = [ dune-configurator ];
  propagatedBuildInputs = [
    ogg
    libtheora
  ];

  meta = with lib; {
    homepage = "https://github.com/savonet/ocaml-theora";
    description = "Bindings to libtheora";
    license = licenses.gpl2Only;
    maintainers = with maintainers; [ dandellion ];
  };
}
