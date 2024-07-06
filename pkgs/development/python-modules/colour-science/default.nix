{ lib
, buildPythonPackage
, fetchFromGitHub
, pythonOlder
# native build dependencies
, poetry-core
# propagated build dependencies
, imageio
, numpy
, scipy
, typing-extensions
# optional dependencies
, matplotlib
, networkx
, opencolorio
, pandas
, tqdm
, xxhash
# graphviz dependencies
, pygraphviz
# meshing dependencies
, trimesh
# tests dependencies
, pytestCheckHook
, pytest-xdist
}:
buildPythonPackage rec {
  pname = "colour-science";
  version = "0.4.4";
  format = "pyproject";
  disabled = pythonOlder "3.9";

  src = fetchFromGitHub {
    owner = "colour-science";
    repo = "colour";
    rev = "refs/tags/v${version}";
    hash = "sha256-o+hSC64vMR41PCXYbi5p/G9jhQZ1+zCINNeCfrhQKrg=";
  };

  nativeBuildInputs = [ poetry-core ];

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
      tqdm
      xxhash
    ];
    graphviz = [
      pygraphviz
    ];
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
  ];

  pythonImportsCheck = [ "colour" ];

  meta = with lib; {
    description = "Colour Science for Python";
    homepage = "https://github.com/colour-science/colour";
    changelog = "https://github.com/colour-science/colour/releases/tag/v${version}";
    license = licenses.bsd3;
    maintainers = with maintainers; [ laurent-f1z1 ];
  };
}
