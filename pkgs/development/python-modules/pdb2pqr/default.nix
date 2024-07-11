{
  lib,
  buildPythonPackage,
  fetchPypi,
  pythonOlder,
  pythonRelaxDepsHook,
  mmcif-pdbx,
  numpy,
  propka,
  requests,
  docutils,
  pytestCheckHook,
  pandas,
  testfixtures,
}:

buildPythonPackage rec {
  pname = "pdb2pqr";
  version = "3.6.2";
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-He301TJ1bzWub0DZ6Ro/Xc+JMtJBbyygVpWjPY6RMbA=";
  };

  nativeBuildInputs = [ pythonRelaxDepsHook ];

  pythonRelaxDeps = [ "docutils" ];

  propagatedBuildInputs = [
    mmcif-pdbx
    numpy
    propka
    requests
    docutils
  ];

  nativeCheckInputs = [
    pytestCheckHook
    pandas
    testfixtures
  ];

  disabledTests = [
    # these tests have network access
    "test_short_pdb"
    "test_basic_cif"
    "test_long_pdb"
    "test_ligand_biomolecule"
    "test_log_output_in_pqr_location"
    "test_propka_apo"
    "test_propka_pka"
    "test_basic"
  ];

  pythonImportsCheck = [ "pdb2pqr" ];

  meta = with lib; {
    description = "Software for determining titration states, adding missing atoms, and assigning charges/radii to biomolecules";
    homepage = "https://www.poissonboltzmann.org/";
    changelog = "https://github.com/Electrostatics/pdb2pqr/releases/tag/v${version}";
    license = licenses.bsd3;
    maintainers = with maintainers; [ natsukium ];
  };
}
