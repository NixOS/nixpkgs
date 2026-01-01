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

<<<<<<< HEAD
  meta = {
    homepage = "https://github.com/savonet/ocaml-theora";
    description = "Bindings to libtheora";
    license = lib.licenses.gpl2Only;
    maintainers = with lib.maintainers; [ dandellion ];
=======
  meta = with lib; {
    homepage = "https://github.com/savonet/ocaml-theora";
    description = "Bindings to libtheora";
    license = licenses.gpl2Only;
    maintainers = with maintainers; [ dandellion ];
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  };
}
