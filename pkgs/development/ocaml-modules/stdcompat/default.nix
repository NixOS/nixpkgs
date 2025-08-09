{
  buildDunePackage,
  ocaml,
  lib,
  fetchFromGitHub,
}:

buildDunePackage rec {
  pname = "stdcompat";
  version = "21.0";

  minimalOCamlVersion = "4.06";

  src = fetchFromGitHub {
    owner = "ocamllibs";
    repo = "stdcompat";
    tag = version;
    hash = "sha256-Ks8m2QicIEohSADiMeijCz0WTPsTSgPifrGTn7FVcV0=";
  };

  # Otherwise ./configure script will run and create files conflicting with dune.
  dontConfigure = true;

  meta = {
    homepage = "https://github.com/thierry-martinez/stdcompat";
    license = lib.licenses.bsd2;
    maintainers = [ lib.maintainers.vbgl ];
  };
}
