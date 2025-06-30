{
  lib,
  buildDunePackage,
  fetchFromGitHub,
  dune-configurator,
  pkg-config,
  frei0r,
}:

buildDunePackage rec {
  pname = "frei0r";
  version = "0.1.2";

  src = fetchFromGitHub {
    owner = "savonet";
    repo = "ocaml-frei0r";
    rev = "v${version}";
    sha256 = "sha256-eh/ymZO/3a1z6uvZdnXgma/7AU2NBVs2lddA+R/kuQA=";
  };

  nativeBuildInputs = [ pkg-config ];
  buildInputs = [ dune-configurator ];
  propagatedBuildInputs = [ frei0r ];

  meta = with lib; {
    homepage = "https://github.com/savonet/ocaml-frei0r";
    description = "Bindings for the frei0r API which provides video effects";
    license = licenses.lgpl21Plus;
    maintainers = with maintainers; [ dandellion ];
  };
}
