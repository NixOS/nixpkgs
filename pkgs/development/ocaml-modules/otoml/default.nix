{ lib, fetchFromGitHub, buildDunePackage
, menhir
, menhirLib
, uutf
}:

buildDunePackage rec {
  pname = "otoml";
  version = "0.9.0";

  useDune2 = true;

  minimalOCamlVersion = "4.08";

  src = fetchFromGitHub {
    owner = "dmbaturin";
    repo = pname;
    rev = version;
    sha256 = "0l0c60rzgk11y8xq05kr8q9hkzb3c8vi995mq84x98ys73wb42j3";
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
