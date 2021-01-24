{ lib, fetchFromGitHub, buildDunePackage, postgresql }:

buildDunePackage rec {
  pname = "postgresql";
  version = "4.6.3";

  minimumOCamlVersion = "4.08";

  src = fetchFromGitHub {
    owner = "mmottl";
    repo = "postgresql-ocaml";
    rev = version;
    sha256 = "0fd96qqwkwjhv6pawk4wivwncszkif0sq05f0g5gd28jzwrsvpqr";
  };

  buildInputs = [ postgresql ];

  meta = {
    description = "Bindings to the PostgreSQL library";
    license = lib.licenses.lgpl21Plus;
    maintainers = with lib.maintainers; [ bcc32 ];
    homepage = "https://mmottl.github.io/postgresql-ocaml";
  };
}
