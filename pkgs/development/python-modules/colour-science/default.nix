{
  lib,
  fetchFromGitHub,
  buildPythonPackage,
  pythonOlder,
  opencolorio,
  hatchling,
  imageio,
  numpy,
  scipy,
  typing-extensions,
  pytestCheckHook,
  pytest-xdist,
  trimesh,
  pydot,
  matplotlib,
  networkx,
  pandas,
  tqdm,
  xxhash,
}:
buildPythonPackage rec {
  pname = "colour-science";
  version = "0.4.6";
  pyproject = true;
  disabled = pythonOlder "3.9";

  src = fetchFromGitHub {
    owner = "colour-science";
    repo = "colour";
    rev = "refs/tags/v${version}";
    hash = "sha256-kjJc6D4jhvAJh6rIVvKO2bw++K3XlfjD4Djav6778lk=";
  };

  nativeBuildInputs = [
    hatchling
  ];

  propagatedBuildInputs = [
    imageio
    numpy
    scipy
    typing-extensions
  ];

  passthru.optional-dependencies = {
    optional = [
      matplotlib
      networkx
      opencolorio
      pandas
      pydot
      tqdm
      xxhash
    ];
    # docs = [
    #   # biblib-simple # not available in nixpkgs
    #   pydata-sphinx-theme
    #   restructuredtext-lint
    #   sphinx
    #   sphinxcontrib-bibtex
    # ];
    meshing = [
      trimesh
    ];
  };

  nativeCheckInputs = [
    pytestCheckHook
    pytest-xdist
  ] ++ lib.flatten (builtins.attrValues passthru.optional-dependencies);

  disabledTests = [
    # slow tests, supposing math is correct and tested upstream
    "test_fairchild1990"
    "test_jakob2019"
    "test_kang2002"
    "test_macadam_limits"
    "test_mallett2019"
    "test_meng2015"
    "test_munsell"
    "test_ohno2013"
    "test_osa_ucs"
    "test_otsu2018"
    "test_pointer_gamut"
    "test_rayleigh"
    "test_rgb"
    "test_robertson1968"
    # not working, problems reading/writing exr files
    "test_write_image_Imageio"
    "test_read_image_Imageio"
    "test_read_image"
    "test_write_image"
    # not working, uses numpy>2 stuff
    "test_machado2009"
    "test_photometry"
  ];

  pythonImportsCheck = [ "colour" ];

  meta = {
    description = "Algorithms and datasets for colour science";
    homepage = "https://github.com/colour-science/colour";
    changelog = "https://github.com/colour-science/colour/releases/tag/v${version}";
    license = lib.licenses.bsd3;
    maintainers = with lib.maintainers; [ laurent-f1z1 ];
  };
}
