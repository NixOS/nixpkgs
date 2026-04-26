{
  lib,
  fetchPypi,
  buildPythonPackage,
  hatchling,
  hatch-vcs,
}:

buildPythonPackage rec {
  pname = "human-readable";
  version = "2.0.3";

  src = fetchPypi {
    pname = "human_readable";
    inherit version;
    hash = "sha256-P4Ef1W7oZpVyyy7J+FK1PuBwB0jlPDaVcx/9mrT8Uks=";
  };

  pyproject = true;

  nativeBuildInputs = [
    hatchling
    hatch-vcs
  ];

  meta = {
    description = "Library to make data intended for machines, readable to humans";
    homepage = "https://github.com/staticdev/human-readable";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ mkg20001 ];
  };
}
