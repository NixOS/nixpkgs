{ lib, stdenv, fetchFromGitHub, fetchpatch, buildDunePackage, pkg-config, gsl, darwin, dune-configurator }:

buildDunePackage rec {
  pname = "gsl";
  version = "1.24.3";

  minimalOCamlVersion = "4.12";

  src = fetchFromGitHub {
    owner = "mmottl";
    repo = "gsl-ocaml";
    rev = version;
    hash = "sha256-I+u7lFEredt8ZLiba8x904eTgSUdZq82/e82B+/GIlo=";
  };

  patches = [
    # Switched to Dune lang 2.7
    (fetchpatch {
      url = "https://github.com/mmottl/gsl-ocaml/commit/be0f6933f16fea6d6fb2e39178816974be4c3724.patch";
      sha256 = "sha256-G/4JT8XPYw+oNJEwJ9zRdUBwtNUHL+T8/htCb3qfuT8=";
    })
    # Fix dune rules
    (fetchpatch {
      url = "https://github.com/mmottl/gsl-ocaml/commit/0b38a22d9813de27eab5caafafeabd945f298b5e.patch";
      sha256 = "sha256-S6OUDase2kR7V6fizaev5huqEAIM5QOkx3n18rj4y3w=";
    })
    # Updated opam file
    (fetchpatch {
      url = "https://github.com/mmottl/gsl-ocaml/commit/b749455b76501c9e3623e05d659565eab7292602.patch";
      sha256 = "sha256-/GACjI3cRCApyGyk1kQp0rB/Hae8DIR9zs6q9KiS1ZQ=";
    })
    # Used new OCaml 4.12 C-macros
    (fetchpatch {
      url = "https://github.com/mmottl/gsl-ocaml/commit/cca79ea56a7ee83a4c67b432decdaef3de8c9d30.patch";
      sha256 = "sha256-bsIKkvj9W8oAYSvP6ZfbqSgt5fSirc780O08WBhVRmI=";
    })
  ];

  duneVersion = "3";

  nativeBuildInputs = [ pkg-config ];
  buildInputs = [ dune-configurator gsl ];
  propagatedBuildInputs = lib.optionals stdenv.isDarwin [ darwin.apple_sdk.frameworks.Accelerate ];

  meta = with lib; {
    homepage = "https://mmottl.github.io/gsl-ocaml/";
    description = "OCaml bindings to the GNU Scientific Library";
    license = licenses.gpl3Plus;
    maintainers = with maintainers; [ vbgl ];
  };
}
