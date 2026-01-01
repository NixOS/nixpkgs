{
  lib,
  buildDunePackage,
  fetchFromGitHub,
  dune-configurator,
  libsamplerate,
}:

<<<<<<< HEAD
buildDunePackage (finalAttrs: {
  pname = "samplerate";
  version = "0.1.6";

  src = fetchFromGitHub {
    owner = "savonet";
    repo = "ocaml-samplerate";
    tag = "v${finalAttrs.version}";
    hash = "sha256-N3PSUSZ1tKNJcNPSgye6+8QQXcZIez72jk/YdNNOEUA=";
=======
buildDunePackage rec {
  pname = "samplerate";
  version = "0.1.6";

  useDune2 = true;

  src = fetchFromGitHub {
    owner = "savonet";
    repo = "ocaml-samplerate";
    rev = "v${version}";
    sha256 = "0h0i9v9p9n2givv3wys8qrfi1i7vp8kq7lnkf14s7d3m4r8x4wrp";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  };

  buildInputs = [ dune-configurator ];
  propagatedBuildInputs = [ libsamplerate ];

<<<<<<< HEAD
  meta = {
    homepage = "https://github.com/savonet/ocaml-samplerate";
    description = "Interface for libsamplerate";
    license = lib.licenses.bsd2;
    maintainers = with lib.maintainers; [ dandellion ];
  };
})
=======
  meta = with lib; {
    homepage = "https://github.com/savonet/ocaml-samplerate";
    description = "Interface for libsamplerate";
    license = licenses.bsd2;
    maintainers = with maintainers; [ dandellion ];
  };
}
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
