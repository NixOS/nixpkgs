{ lib
, fetchFromGitHub
, buildDunePackage
, menhir
, menhirLib
, uutf
}:

buildDunePackage rec {
  pname = "otoml";
  version = "1.0.1";

  useDune2 = true;

  minimalOCamlVersion = "4.08";

  src = fetchFromGitHub {
    owner = "dmbaturin";
    repo = pname;
    rev = version;
    sha256 = "sha256-2WGuq4ZLbLvfG6WZ3iimiSMqMYHCuruZc1EttZ/5rBE=";
  };

  strictDeps = true;

  nativeBuildInputs = [ menhir ];

  propagatedBuildInputs = [ menhirLib uutf ];

  meta = {
    description = "A TOML parsing and manipulation library for OCaml";
    license = lib.licenses.mit;
    maintainers = [ lib.maintainers.vbgl ];
    inherit (src.meta) homepage;
  };
}
