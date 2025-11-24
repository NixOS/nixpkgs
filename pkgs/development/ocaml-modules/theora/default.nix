{
  lib,
  buildDunePackage,
  fetchFromGitHub,
  dune-configurator,
  ogg,
  libtheora,
}:

buildDunePackage {
  pname = "theora";
  inherit (ogg) version src;

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
