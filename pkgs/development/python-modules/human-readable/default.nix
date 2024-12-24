{
  lib,
  fetchPypi,
  buildPythonPackage,
  hatchling,
  hatch-vcs,
}:

buildPythonPackage rec {
  pname = "human-readable";
  version = "1.3.4";

  src = fetchPypi {
    pname = "human_readable";
    inherit version;
    hash = "sha256-VybqyJBm7CXRREehc+ZFqFUYRkXQJOswZwXiv7tg8MA=";
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
