{
  lib,
  buildDunePackage,
  fetchFromGitHub,
  dune-configurator,
  ogg,
  speex,
}:

buildDunePackage {
  pname = "speex";
  inherit (ogg) version src;

  buildInputs = [ dune-configurator ];
  propagatedBuildInputs = [
    ogg
    speex.dev
  ];

  meta = with lib; {
    homepage = "https://github.com/savonet/ocaml-speex";
    description = "Bindings to libspeex";
    license = licenses.gpl2Only;
    maintainers = with maintainers; [ dandellion ];
  };
}
