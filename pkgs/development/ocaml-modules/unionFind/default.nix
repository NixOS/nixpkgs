{
  lib,
  fetchFromGitLab,
  buildDunePackage,
}:

buildDunePackage rec {
  pname = "unionFind";
  version = "20220122";

  useDune2 = true;
  minimalOCamlVersion = "4.05";

  src = fetchFromGitLab {
    domain = "gitlab.inria.fr";
    owner = "fpottier";
    repo = pname;
    rev = version;
    sha256 = "sha256:0hdh56rbg8vfjd61q09cbmh8l5wmry5ykivg7gsm0v5ckkb3531r";
  };

  meta = {
    description = "Implementations of the union-find data structure";
    license = lib.licenses.lgpl2Only;
    inherit (src.meta) homepage;
    maintainers = [ lib.maintainers.vbgl ];
  };
}
