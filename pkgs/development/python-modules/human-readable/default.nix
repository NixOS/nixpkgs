{
  lib,
  fetchPypi,
  buildPythonPackage,
  hatchling,
  hatch-vcs,
}:

buildPythonPackage rec {
  pname = "human-readable";
  version = "1.4.1";

  src = fetchPypi {
    pname = "human_readable";
    inherit version;
    hash = "sha256-yBv6A10ogYM3mVRqbxLnG6TB76fdpqi+wQ/WunhQIR8=";
  };

  pyproject = true;

  nativeBuildInputs = [
    hatchling
    hatch-vcs
  ];

  meta = with lib; {
    description = "Library to make data intended for machines, readable to humans";
    homepage = "https://github.com/staticdev/human-readable";
    license = licenses.mit;
    maintainers = with maintainers; [ mkg20001 ];
  };
}
