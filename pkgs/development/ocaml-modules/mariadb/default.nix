{ lib, fetchFromGitHub, buildOasisPackage
, ctypes, mariadb, libmysqlclient }:

buildOasisPackage rec {
  pname = "mariadb";
  version = "1.1.4";

  minimumOCamlVersion = "4.07.0";

  src = fetchFromGitHub {
    owner = "andrenth";
    repo = "ocaml-mariadb";
    rev = version;
    sha256 = "1rxqvxr6sv4x2hsi05qm9jz0asaq969m71db4ckl672rcql1kwbr";
  };

  buildInputs = [ mariadb libmysqlclient ];
  propagatedBuildInputs = [ ctypes ];

  meta = {
    description = "OCaml bindings for MariaDB";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ bcc32 ];
    homepage = "https://github.com/andrenth/ocaml-mariadb";
  };
}
