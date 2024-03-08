{ lib
, buildDunePackage
, fetchurl
, riot
, tty
}:

buildDunePackage rec {
  pname = "minttea";
  version = "0.0.1";

  minimalOCamlVersion = "5.1";

  src = fetchurl {
    url = "https://github.com/leostera/minttea/releases/download/${version}/minttea-${version}.tbz";
    hash = "sha256-+4nVeYKx2A2i2nll/PbStcEa+Dvxd0T7e/KsdJqY4bI=";
  };

  propagatedBuildInputs = [
    riot
    tty
  ];

  doCheck = true;

  meta = {
    description = "A fun, functional, and stateful way to build terminal apps in OCaml heavily inspired by Go's BubbleTea";
    homepage = "https://github.com/leostera/minttea";
    changelog = "https://github.com/leostera/minttea/blob/${version}/CHANGES.md";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ sixstring982 ];
  };
}
