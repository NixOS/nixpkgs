{
  buildPythonPackage,
  fetchPypi,
  lib,
  domdf-python-tools,
  handy-archives,
  hatchling,
  hatch-requirements-txt,
  packaging,
}:
buildPythonPackage rec {
  pname = "dist-meta";
  version = "0.9.0";
  pyproject = true;

  src = fetchPypi {
    pname = "dist_meta";
    inherit version;
    hash = "sha256-+hbr1VdHRKCVlqs0IIOhHXIJ2NBc8yiR0cmFvn7Ay9c=";
  };

  build-system = [
    hatchling
    hatch-requirements-txt
  ];

  dependencies = [
    domdf-python-tools
    handy-archives
    packaging
  ];

  meta = {
    description = "Parse and create Python distribution metadata";
    homepage = "https://github.com/repo-helper/dist-meta";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ tyberius-prime ];
  };
}
