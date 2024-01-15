{ lib
, buildPythonPackage
, fetchFromGitHub
, setuptools
, wheel
, numpy
, openmm
, pytestCheckHook
}:

buildPythonPackage rec {
  pname = "pdbfixer";
  version = "1.9";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "openmm";
    repo = "pdbfixer";
    rev = version;
    hash = "sha256-ZXQWdNQyoVgjpZj/Wimcfwcbxk3CIvg3n5S1glNYUP4=";
  };

  nativeBuildInputs = [
    setuptools
    wheel
  ];

  propagatedBuildInputs = [
    numpy
    openmm
  ];

  nativeCheckInputs = [
    pytestCheckHook
  ];

  preCheck = ''
    export PATH=$out/bin:$PATH
  '';

  disabledTests = [
    # require network access
    "test_build_and_simulate"
    "test_mutate_1"
    "test_mutate_2"
    "test_mutate_3_fails"
    "test_mutate_4_fails"
    "test_mutate_5_fails"
    "test_mutate_multiple_copies_of_chain_A"
    "test_pdbid"
    "test_url"
  ];

  pythonImportsCheck = [ "pdbfixer" ];

  meta = with lib; {
    description = "PDBFixer fixes problems in PDB files";
    homepage = "https://github.com/openmm/pdbfixer";
    changelog = "https://github.com/openmm/pdbfixer/releases/tag/${src.rev}";
    license = licenses.mit;
    maintainers = with maintainers; [ natsukium ];
    mainProgram = "pdbfixer";
  };
}
