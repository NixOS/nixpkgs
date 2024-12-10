{
  lib,
  stdenv,
  fetchFromGitHub,
  buildDunePackage,
  pkg-config,
  gsl,
  darwin,
  dune-configurator,
}:

buildDunePackage rec {
  pname = "gsl";
  version = "1.25.0";

  minimalOCamlVersion = "4.12";

  src = fetchFromGitHub {
    owner = "mmottl";
    repo = "gsl-ocaml";
    rev = version;
    hash = "sha256-vxXv0ZcToXmdYu5k0aLdV3seNn3Y6Sgg+8dpy3Iw68I=";
  };

  nativeBuildInputs = [ pkg-config ];
  buildInputs = [
    dune-configurator
    gsl
  ];
  propagatedBuildInputs = lib.optionals stdenv.isDarwin [ darwin.apple_sdk.frameworks.Accelerate ];

  meta = with lib; {
    homepage = "https://mmottl.github.io/gsl-ocaml/";
    description = "OCaml bindings to the GNU Scientific Library";
    license = licenses.gpl3Plus;
    maintainers = with maintainers; [ vbgl ];
  };
}
