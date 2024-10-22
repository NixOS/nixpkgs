{ lib, mkCoqDerivation, coq, version ? null }:

mkCoqDerivation {
  pname = "high-school-geometry";
  inherit version;
  repo = "HighSchoolGeometry";
  defaultVersion = with lib.versions; lib.switch coq.coq-version [
    { case = range "8.16" "8.20"; out = "8.16"; }
    { case = range "8.12" "8.16"; out = "8.13"; }
    { case = "8.12"; out = "8.12"; }
    { case = "8.11"; out = "8.11"; }
  ] null;

  release = {
    "8.16".sha256 = "sha256-HvUrZ6l7wCshuKUZs8rvfMkTEv+oXuogI5LICcD8Bn8=";
    "8.13".sha256 = "sha256-5F/6155v0bWi5t7n4qU/GuR6jENngvWIIqJGPURzIeQ=";
    "8.12".sha256 = "sha256-OF7sahU+5Ormkcrd8t6p2Kp/B2/Q/6zYTV3/XBvlGHc=";
    "8.11".sha256 = "sha256-sVGeBBAJ7a7f+EJU1aSUvIVe9ip9PakY4379XWvvoqw=";
  };
  releaseRev = v: "v${v}";

  meta = with lib; {
    description = "Geometry in Coq for French high school";
    maintainers = with maintainers; [ definfo ];
    license = licenses.lgpl21Plus;
  };
}
