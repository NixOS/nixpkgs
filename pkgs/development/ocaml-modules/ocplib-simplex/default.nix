{
  lib,
  fetchFromGitHub,
  buildDunePackage,
  logs,
  num,
}:

buildDunePackage rec {
  pname = "ocplib-simplex";
  version = "0.5";

  src = fetchFromGitHub {
    owner = "OCamlPro-Iguernlala";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-sy5QUmghG28tXlwbKWx3PpBGTtzXarTSzd1WLSYyvbc=";
  };

  propagatedBuildInputs = [
    logs
    num
  ];

  doCheck = true;

  meta = {
    description = "OCaml library implementing a simplex algorithm, in a functional style, for solving systems of linear inequalities";
    homepage = "https://github.com/OCamlPro-Iguernlala/ocplib-simplex";
    license = lib.licenses.lgpl21Only;
    maintainers = [ lib.maintainers.vbgl ];
  };
}
