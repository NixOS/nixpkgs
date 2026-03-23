{
  lib,
  fetchPypi,
  buildPythonPackage,
  hatchling,
  hatch-vcs,
}:

buildPythonPackage rec {
  pname = "human-readable";
  version = "2.0.1";

  src = fetchPypi {
    pname = "human_readable";
    inherit version;
    hash = "sha256-7Iky53uBlvvQ+UQLI8gP+glk6nb/llg29gT0HuSLWU8=";
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
