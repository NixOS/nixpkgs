{
  lib,
  fetchPypi,
  buildPythonPackage,
  hatchling,
  hatch-vcs,
}:

buildPythonPackage rec {
  pname = "human-readable";
  version = "2.0.2";

  src = fetchPypi {
    pname = "human_readable";
    inherit version;
    hash = "sha256-I2s/hqxUexK2yizqiJt4HF5yceR7mM3ieV862ZaDs84=";
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
