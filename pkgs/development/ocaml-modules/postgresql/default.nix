{ lib, fetchFromGitHub, buildDunePackage, dune-configurator, libpq }:

buildDunePackage rec {
  pname = "postgresql";
  version = "5.0.0";

  useDune2 = true;

  minimalOCamlVersion = "4.08";

  src = fetchFromGitHub {
    owner = "mmottl";
    repo = "postgresql-ocaml";
    rev = version;
    sha256 = "1i4pnh2v00i0s7s9pcwz1x6s4xcd77d08gjjkvy0fmda6mqq6ghn";
  };

  buildInputs = [ dune-configurator ];
  propagatedBuildInputs = [ libpq ];

  meta = {
    description = "Bindings to the PostgreSQL library";
    license = lib.licenses.lgpl21Plus;
    maintainers = with lib.maintainers; [ bcc32 ];
    homepage = "https://mmottl.github.io/postgresql-ocaml";
  };
}
