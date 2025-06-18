{
  lib,
  python3,
  python3Packages,
  fetchPypi,
}:
python3Packages.buildPythonPackage rec {
  pname = "pycvc";
  version = "1.5.0";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-ePm9EP+VgnB7EGe6DalmxOH+r3AY4gaihzYAJEnOyvI=";
  };

  propagatedBuildInputs = (with python3.pkgs; [ cryptography ]);

  meta = {
    description = "Card Verifiable Certificates (CVC) tools for Python";
    homepage = "https://github.com/polhenarejos/pycvc";
    license = lib.licenses.gpl3Only;
    maintainers = with lib.maintainers; [ oluceps ];
    mainProgram = "pycvc";
  };
}
