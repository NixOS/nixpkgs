{ lib
, fetchFromGitHub
, buildDunePackage
, zarith
}:

buildDunePackage rec {
  pname = "vpl-core";
  version = "0.5";

  minimalOCamlVersion = "4.07";

  src = fetchFromGitHub {
    owner = "VERIMAG-Polyhedra";
    repo = "vpl";
    rev = version;
    hash = "sha256-mSD/xSweeK9WMxWDdX/vzN96iXo74RkufjuNvtzsP9o=";
  };

  propagatedBuildInputs = [
    zarith
  ];

  meta = {
    description = "Verified Polyhedra Library";
    homepage = "https://amarechal.gitlab.io/home/projects/vpl/";
    license = lib.licenses.lgpl3Only;
    maintainers = [ lib.maintainers.vbgl ];
  };

}
