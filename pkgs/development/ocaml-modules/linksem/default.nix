{
  lib,
  fetchFromGitHub,
  stdenv,
  findlib,
  ocaml,
  lem,
}:

lib.throwIfNot (lib.versionAtLeast ocaml.version "4.07")
  "linksem is not available for OCaml ${ocaml.version}"

  stdenv.mkDerivation
  rec {
    pname = "ocaml${ocaml.version}-linksem";
    version = "0.8";

    src = fetchFromGitHub {
      owner = "rems-project";
      repo = "linksem";
      rev = version;
      hash = "sha256-7/YfDK3TruKCckMzAPLRrwBkHRJcX1S+AzXHWRxkZPA=";
    };

    nativeBuildInputs = [
      findlib
      ocaml
    ];

    propagatedBuildInputs = [ lem ];

    createFindlibDestdir = true;

    meta = with lib; {
      homepage = "https://github.com/rems-project/linksem";
      description = "A formalisation of substantial parts of ELF linking and DWARF debug information";
      maintainers = with maintainers; [ genericnerdyusername ];
      license = licenses.bsd2;
      platforms = ocaml.meta.platforms;
    };
  }
