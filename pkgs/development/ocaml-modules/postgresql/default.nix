{ lib, fetchFromGitHub, buildDunePackage, dune-configurator, postgresql }:

buildDunePackage rec {
  pname = "postgresql";
  version = "5.1.3";

  useDune2 = true;

  minimalOCamlVersion = "4.08";

  src = fetchFromGitHub {
    owner = "mmottl";
    repo = "postgresql-ocaml";
    rev = version;
    sha256 = "sha256-XyOA7q6r+3osmaQpz61YmMBh0STN6Jdf5gbGX25SYA4=";
  };

  nativeBuildInputs = [ postgresql ];
  buildInputs = [ dune-configurator ];
  propagatedBuildInputs = [ postgresql ];

  meta = {
    description = "Bindings to the PostgreSQL library";
    license = lib.licenses.lgpl21Plus;
    maintainers = with lib.maintainers; [ bcc32 ];
    homepage = "https://mmottl.github.io/postgresql-ocaml";
  };
}
