{
  lib,
  buildDunePackage,
  fetchFromGitHub,
  dune-configurator,
  libsamplerate,
  libjack2,
}:

buildDunePackage rec {
  pname = "bjack";
  version = "0.1.6";

  src = fetchFromGitHub {
    owner = "savonet";
    repo = "ocaml-bjack";
    rev = "v${version}";
    hash = "sha256-jIxxqBVWphWYyLh+24rTxk4WWfPPdGCvNdevFJEKw70=";
  };

  buildInputs = [ dune-configurator ];
  propagatedBuildInputs = [
    libsamplerate
    libjack2
  ];

<<<<<<< HEAD
  meta = {
    homepage = "https://github.com/savonet/ocaml-bjack";
    description = "Blocking API for the jack audio connection kit";
    license = lib.licenses.lgpl21Only;
    maintainers = with lib.maintainers; [ dandellion ];
=======
  meta = with lib; {
    homepage = "https://github.com/savonet/ocaml-bjack";
    description = "Blocking API for the jack audio connection kit";
    license = licenses.lgpl21Only;
    maintainers = with maintainers; [ dandellion ];
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  };
}
