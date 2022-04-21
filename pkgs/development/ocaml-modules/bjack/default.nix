{ lib, buildDunePackage, fetchFromGitHub, dune-configurator, libsamplerate, libjack2 }:

buildDunePackage rec {
  pname = "bjack";
  version = "0.1.6";

  useDune2 = true;

  src = fetchFromGitHub {
    owner = "savonet";
    repo = "ocaml-bjack";
    rev = "v${version}";
    sha256 = "1gf31a8i9byp6npn0x6gydcickn6sf5dnzmqr2c1b9jn2nl7334c";
  };

  buildInputs = [ dune-configurator ];
  propagatedBuildInputs = [ libsamplerate libjack2 ];

  meta = with lib; {
    homepage = "https://github.com/savonet/ocaml-bjack";
    description = "Blocking API for the jack audio connection kit";
    license = licenses.lgpl21Only;
    maintainers = with maintainers; [ dandellion ];
  };
}
