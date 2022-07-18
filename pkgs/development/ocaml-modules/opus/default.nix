{ lib, buildDunePackage, fetchFromGitHub, dune-configurator, pkg-config, ogg, libopus }:

buildDunePackage rec {
  pname = "opus";
  version = "0.2.1";

  useDune2 = true;

  src = fetchFromGitHub {
    owner = "savonet";
    repo = "ocaml-opus";
    rev = "v${version}";
    sha256 = "09mgnprhhs1adqm25c0qjhknswbh6va3jknq06fnp1jszszcjf4s";
  };

  nativeBuildInputs = [ pkg-config ];
  buildInputs = [ dune-configurator ];
  propagatedBuildInputs = [ ogg libopus.dev ];

  meta = with lib; {
    homepage = "https://github.com/savonet/ocaml-opus";
    description = "Bindings to libopus";
    license = licenses.gpl2Only;
    maintainers = with maintainers; [ dandellion ];
  };
}
