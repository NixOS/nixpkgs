{ lib, stdenv, buildDunePackage, fetchFromGitHub, Accelerate, CoreAudio, dune-configurator, libsamplerate, libjack2 }:

buildDunePackage rec {
  pname = "bjack";
  version = "0.1.6";

  src = fetchFromGitHub {
    owner = "savonet";
    repo = "ocaml-bjack";
    rev = "v${version}";
    hash = "sha256-jIxxqBVWphWYyLh+24rTxk4WWfPPdGCvNdevFJEKw70=";
  };

  buildInputs = [ dune-configurator ] ++ lib.optionals stdenv.isDarwin [ Accelerate CoreAudio ];
  propagatedBuildInputs = [ libsamplerate libjack2 ];

  meta = with lib; {
    homepage = "https://github.com/savonet/ocaml-bjack";
    description = "Blocking API for the jack audio connection kit";
    license = licenses.lgpl21Only;
    maintainers = with maintainers; [ dandellion ];
  };
}
