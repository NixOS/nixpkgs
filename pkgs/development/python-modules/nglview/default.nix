{ lib
, buildPythonPackage
, fetchPypi
, pythonOlder
, ase
, ipywidgets
, jupyter-packaging
, jupyterlab-widgets
, mock
, moviepy
, notebook
, numpy
, pillow
, pytestCheckHook
, qcelemental
, rdkit
, setuptools
, versioneer
, wheel
}:

buildPythonPackage rec {
  pname = "nglview";
  version = "3.0.8";
  pyproject = true;

  disabled = pythonOlder "3.6";

  # we need the npm package for the front end, but there is no lock file on github
  src = fetchPypi {
    inherit pname version;
    hash = "sha256-+eRozYE9rDGcvspq4grgmQCP86BjmfXSPXVYLd4oYjo=";
  };

  postPatch = ''
    substituteInPlace pyproject.toml \
      --replace "jupyter_packaging~=0.7.9" "jupyter_packaging" \
      --replace '"versioneer-518"' ""
  '';

  nativeBuildInputs = [
    jupyter-packaging
    setuptools
    versioneer
    wheel
  ];

  propagatedBuildInputs = [
    ipywidgets
    jupyterlab-widgets
    numpy
  ];

  passthru.optional-dependencies = {
    simpletraj = [
      # simpletraj
    ];
    mdtraj = [
      # mdtraj
    ];
    pytraj = [
      # pytraj
    ];
    MDAnalysis = [
      # mdanalysis
    ];
    ParmEd = [
      # parmed
    ];
    rdkit = [
      rdkit
    ];
    ase = [
      ase
    ];
    htmd = [
      # htmd
    ];
    qcelemental = [
      qcelemental
    ];
  };

  nativeCheckInputs = [
    pytestCheckHook
    mock
    pillow
    notebook
    moviepy
  ] ++ lib.flatten (builtins.attrValues passthru.optional-dependencies);

  disabledTests = [
    # require simpletraj
    "test_API_promise_to_have"
    "test_add_repr_shortcut"
    "test_component_for_duck_typing"
    "test_coordinates_dict"
    "test_download_image"
    "test_handling_n_components_changed"
    "test_interpolate"
    "test_load_data"
    "test_loaded_attribute"
    "test_movie_maker"
    "test_player_interpolation"
    "test_player_link_to_ipywidgets"
    "test_player_simple"
    "test_remote_call"
    "test_representations"
    "test_trajectory_show_hide_sending_cooridnates"
    "test_write_html"

    # require parmed
    "test_show_schrodinger"

    # require notebook<7
    "test_get_port"

    # pypi's sdist has no test data
    "test_add_struture_then_trajectory"
    "test_cli"
    "test_file_current_folder"
    "test_file_gz"
    "test_file_passing_blob"
    "test_file_passing_blob_from_gzip"
    "test_structure_file"

    # require network access
    "test_nglview_show_module"
    "test_nglview_widget"
  ];

  pythonImportsCheck = [ "nglview" ];

  meta = with lib; {
    description = "Jupyter widget to interactively view molecular structures and trajectories";
    homepage = "https://github.com/nglviewer/nglview";
    changelog = "https://github.com/nglviewer/nglview/blob/${src.rev}/CHANGELOG.md";
    license = licenses.mit;
    maintainers = with maintainers; [ natsukium ];
  };
}
