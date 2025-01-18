{
  lib,
  buildDunePackage,
  fetchFromGitHub,
  re,
}:

buildDunePackage rec {
  pname = "calendar";
  version = "3.0.0";
  minimalOCamlVersion = "4.03";

  src = fetchFromGitHub {
    owner = "ocaml-community";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-+VQzi6pEMqzV1ZR84Yjdu4jsJEWtx+7bd6PQGX7TiEs=";
  };

  propagatedBuildInputs = [ re ];

  meta = with lib; {
    inherit (src.meta) homepage;
    description = "Library for handling dates and times";
    license = licenses.lgpl21Plus;
    maintainers = [ maintainers.gal_bolle ];
  };
}
