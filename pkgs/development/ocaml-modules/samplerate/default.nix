{
  lib,
  buildDunePackage,
  fetchFromGitHub,
  dune-configurator,
  libsamplerate,
}:

buildDunePackage rec {
  pname = "samplerate";
  version = "0.1.6";

  useDune2 = true;

  src = fetchFromGitHub {
    owner = "savonet";
    repo = "ocaml-samplerate";
    rev = "v${version}";
    sha256 = "0h0i9v9p9n2givv3wys8qrfi1i7vp8kq7lnkf14s7d3m4r8x4wrp";
  };

  buildInputs = [ dune-configurator ];
  propagatedBuildInputs = [ libsamplerate ];

  meta = with lib; {
    homepage = "https://github.com/savonet/ocaml-samplerate";
    description = "Interface for libsamplerate";
    license = licenses.bsd2;
    maintainers = with maintainers; [ dandellion ];
  };
}
