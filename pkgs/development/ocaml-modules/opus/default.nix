{
  lib,
  buildDunePackage,
  fetchFromGitHub,
  dune-configurator,
  pkg-config,
  ogg,
  libopus,
}:

buildDunePackage {
  pname = "opus";
  inherit (ogg) version src;

  nativeBuildInputs = [ pkg-config ];
  buildInputs = [ dune-configurator ];
  propagatedBuildInputs = [
    ogg
    libopus.dev
  ];

<<<<<<< HEAD
  meta = {
    homepage = "https://github.com/savonet/ocaml-opus";
    description = "Bindings to libopus";
    license = lib.licenses.gpl2Only;
    maintainers = with lib.maintainers; [ dandellion ];
=======
  meta = with lib; {
    homepage = "https://github.com/savonet/ocaml-opus";
    description = "Bindings to libopus";
    license = licenses.gpl2Only;
    maintainers = with maintainers; [ dandellion ];
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  };
}
