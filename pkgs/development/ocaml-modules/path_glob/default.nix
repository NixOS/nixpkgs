{
  lib,
  buildDunePackage,
  fetchurl,
}:

buildDunePackage rec {
  pname = "path_glob";
  version = "0.2";
  useDune2 = true;
  src = fetchurl {
    url = "https://gasche.gitlab.io/path_glob/releases/path_glob-${version}.tbz";
    sha256 = "01ra20bzjiihbgma74axsp70gqmid6x7jmiizg48mdkni0aa42ay";
  };

  meta = {
    homepage = "https://gitlab.com/gasche/path_glob";
    description = "Checking glob patterns on paths";
    license = lib.licenses.lgpl2Only;
  };
}
