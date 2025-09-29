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

  meta = {
    homepage = "https://github.com/savonet/ocaml-speex";
    description = "Bindings to libspeex";
    license = lib.licenses.gpl2Only;
    maintainers = with lib.maintainers; [ dandellion ];
  };
}
