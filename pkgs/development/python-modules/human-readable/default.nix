{
  lib,
  fetchPypi,
  buildPythonPackage,
  hatchling,
  hatch-vcs,
}:

buildPythonPackage rec {
  pname = "human-readable";
  version = "2.0.0";

  src = fetchPypi {
    pname = "human_readable";
    inherit version;
    hash = "sha256-VuuUReVgzPoGlZCK4uyLAIG4bUnroaCDO8CuD0TWxOk=";
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
