{ lib
, fetchFromGitHub
, stdenv

, findlib
, ocaml
, lem
, num
}:

stdenv.mkDerivation rec {
  pname = "linksem";
  version = "0.8";

  minimalOCamlVersion = "4.06";

  nativeBuildInputs = [ findlib ocaml ];
  buildInputs = [ lem num ];

  preInstall = "mkdir -p $OCAMLFIND_DESTDIR";

  src = fetchFromGitHub {
    owner = "rems-project";
    repo = pname;
    rev = version;
    hash = "sha256-7/YfDK3TruKCckMzAPLRrwBkHRJcX1S+AzXHWRxkZPA=";
  };

  meta = with lib; {
    homepage = "https://github.com/rems-project/linksem";
    description = "Linksem is a formalisation of substantial parts of ELF linking and DWARF debug information";
    maintainers = with maintainers; [ genericnerdyusername ];
    license = licenses.bsd2;
  };
}
