{
  buildPythonPackage,
  fetchFromGitHub,
  lib,
  pandas,
  pyyaml,
  serializable,
}:

buildPythonPackage {
  pname = "mhcgnomes";
  version = "1.8.6";
  format = "setuptools";

  src = fetchFromGitHub {
    owner = "pirl-unc";
    repo = "mhcgnomes";
    # See https://github.com/pirl-unc/mhcgnomes/issues/20. As of 2023-07-13,
    # they do no have version tags.
    rev = "c7e779b60e35a031f6e0f0ea6ae70e8a8e7671c6";
    hash = "sha256-KKiBlnFlavRnaQnOpAzG0dyxmFB+zF9L6t/H05LkFZE=";
  };

  propagatedBuildInputs = [
    pandas
    pyyaml
    serializable
  ];

  pythonImportsCheck = [ "mhcgnomes" ];

  meta = with lib; {
    description = "Parsing MHC nomenclature in the wild";
    homepage = "https://github.com/pirl-unc/mhcgnomes";
    license = licenses.asl20;
    maintainers = with maintainers; [ samuela ];
  };
}
