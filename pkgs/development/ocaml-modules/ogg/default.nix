{ lib, buildDunePackage, fetchFromGitHub, dune-configurator, libogg }:

buildDunePackage rec {
  pname = "ogg";
  version = "0.7.3";

  useDune2 = true;

  src = fetchFromGitHub {
    owner = "savonet";
    repo = "ocaml-ogg";
    rev = "v${version}";
    sha256 = "sha256-D6tLKBSGfWBoMfQrWmamd8jo2AOphJV9xeSm+l06L5c=";
  };

  buildInputs = [ dune-configurator ];
  propagatedBuildInputs = [ libogg ];

  meta = with lib; {
    homepage = "https://github.com/savonet/ocaml-ogg";
    description = "Bindings to libogg";
    license = licenses.lgpl21Only;
    maintainers = with maintainers; [ dandellion ];
  };
}
