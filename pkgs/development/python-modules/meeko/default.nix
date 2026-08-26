{
  lib,
  stdenv,
  buildPythonPackage,
  fetchFromGitHub,

  # build-system
  setuptools,

  # dependencies
  gemmi,
  numpy,
  rdkit,
  scipy,

  # tests
  pytestCheckHook,
}:

buildPythonPackage rec {
  pname = "meeko";
  version = "0.7.1";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "forlilab";
    repo = "Meeko";
    tag = "v${version}";
    hash = "sha256-ObGUUNzfK2k37uJ/aY3DHf9BlJ1nzqTe6tHvV2rj1og=";
  };

  build-system = [
    setuptools
  ];

  dependencies = [
    gemmi
    numpy
    rdkit
    scipy
  ];

  nativeCheckInputs = [ pytestCheckHook ];

  disabledTests = [
    # Require internet connection
    "test_add_variants"
    "test_build_noncovalent_CC"

    # AssertionError: assert {'chosen_by_d...ond': [], ...} == {'chosen_by_d...ond': [], ...}
    "test_polymer_encoding_decoding"
  ]
  ++ lib.optionals stdenv.hostPlatform.isDarwin [
    # AssertionError: assert 'altloc' in 'updated 1 h positions but deleted 11
    "test_AHHY_all_static_residues"
    "test_AHHY_flex_residues"
    "test_AHHY_flexibilize_then_parameterize"
    "test_AHHY_mk_prep_and_export"
    "test_AHHY_mutate_residues"
    "test_AHHY_padding"
    "test_disulfide_adjacent"
    "test_disulfides"
    "test_export_sidechains_no_idxmap"
    "test_insertion_code"
    "test_just_three_padded_mol"
    "test_monomer_encoding_decoding"
    "test_pdbqt_writing_from_decoded_polymer"
    "test_rdkit_molsetup_encoding_decoding"
    "test_residue_chem_templates_encoding_decoding"
    "test_residue_padder_encoding_decoding"
    "test_residue_template_encoding_decoding"
    "test_stitch_polymer"
    "test_write_pdb_1igy"
    "test_write_pdb_AHHY"

    # RuntimeError: Updated 1 H positions but deleted 10
    "test_altloc"
  ];

  pythonImportsCheck = [ "meeko" ];

  meta = {
    description = "Python package for preparing small molecule for docking";
    homepage = "https://github.com/forlilab/Meeko";
    changelog = "https://github.com/forlilab/Meeko/releases/tag/${src.tag}";
    license = lib.licenses.lgpl21Only;
    maintainers = with lib.maintainers; [ natsukium ];
  };
}
