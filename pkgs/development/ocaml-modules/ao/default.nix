{
  lib,
  buildDunePackage,
  fetchFromGitHub,
  dune-configurator,
  libao,
}:

buildDunePackage rec {
  pname = "ao";
  version = "0.2.4";

  src = fetchFromGitHub {
    owner = "savonet";
    repo = "ocaml-ao";
    rev = "v${version}";
    sha256 = "sha256-HhJdb4i9B4gz3emgDCDT4riQuAsY4uP/47biu7EZ+sk=";
  };

  buildInputs = [ dune-configurator ];
  propagatedBuildInputs = [ libao ];

  meta = with lib; {
    homepage = "https://github.com/savonet/ocaml-ao";
    description = "OCaml bindings for libao";
    license = licenses.lgpl21Plus;
    maintainers = with maintainers; [ dandellion ];
  };
}
