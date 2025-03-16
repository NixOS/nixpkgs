{ lib
, buildPythonPackage
, fetchFromGitHub
, setuptools
, wheel
, nglview
, numpy
, pandas
, pillow
, pytestCheckHook
, requests
, scikit-learn
, scipy
, torch
, tqdm
, transformers
, xdg-base-dirs
}:

buildPythonPackage {
  pname = "generate-chroma";
  version = "unstable-2023-11-15";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "generatebio";
    repo = "chroma";
    rev = "81f6612175f5336e1097bdb7c4339c11211a23f8";
    hash = "sha256-BefAO5nxfUufoTFJ0QHwNsPzNjABoQgdirIdkRqfTOM=";
  };

  postPatch = ''
    substituteInPlace chroma/utility/api.py \
      --replace "ROOT_DIR = os.path.dirname(os.path.dirname(chroma.__file__))" "from xdg_base_dirs import xdg_data_home; ROOT_DIR = xdg_data_home() / 'generate-chroma'"
    substituteInPlace chroma/layers/structure/protein_graph.py \
      --replace "basepath = os.path.dirname(os.path.abspath(__file__))" "from xdg_base_dirs import xdg_data_home; basepath = str(xdg_data_home() / 'generate-chroma')"
  '';

  nativeBuildInputs = [
    setuptools
    wheel
  ];

  propagatedBuildInputs = [
    nglview
    numpy
    pandas
    pillow
    requests
    scikit-learn
    scipy
    torch
    tqdm
    transformers
    xdg-base-dirs
  ];

  nativeCheckInputs = [
    pytestCheckHook
  ];

  preCheck = ''
    export HOME=$TMPDIR
  '';

  disabledTests = [
    # require network access
    "test_Protein"
    "test_atom_placement"
    "test_backbone_hbonds"
    "test_backbone_rmsd"
    "test_chi_cartesian_round_trip"
    "test_chroma"
    "test_cmvn"
    "test_denoiser"
    "test_design"
    "test_deterministic_traversal"
    "test_edge_cases"
    "test_elbo"
    "test_equivariance_denoiser"
    "test_equivariance_graph_update"
    "test_fragment_pair_rmsd"
    "test_fragment_rmsd"
    "test_frame_builder_round_trip"
    "test_graph_classifier"
    "test_graph_design_outputs"
    "test_integration"
    "test_invertibility_R"
    "test_invertibility_X_Z"
    "test_invertibility_covariance"
    "test_log_determinant"
    "test_logp"
    "test_loss_hbb"
    "test_masked_interfaces"
    "test_neighborhood_rmsd"
    "test_procap"
    "test_proclass_conditioner"
    "test_protein_feature_graph"
    "test_reading_cif"
    "test_reading_pdb"
    "test_reconloss"
    "test_sample"
    "test_sample_backbone"
    "test_sample_sde"
    "test_sampling"
    "test_sequential_decoding"
    "test_writing_pdb"
  ];

  disabledTestPaths = [
    # there is no test data
    "tests/data/test_system.py"
  ];

  pythonImportsCheck = [ "chroma" ];

  meta = with lib; {
    description = "A generative model for programmable protein design";
    homepage = "https://github.com/generatebio/chroma";
    license = licenses.asl20;
    maintainers = with maintainers; [ natsukium ];
  };
}
