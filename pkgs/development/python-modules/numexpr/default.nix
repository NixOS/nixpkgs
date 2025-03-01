{
  lib,
  buildPythonPackage,
  fetchPypi,
  numpy,
  pytestCheckHook,
  setuptools,
}:

buildPythonPackage rec {
  pname = "numexpr";
  version = "2.10.2";
  pyproject = true;

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-sK/2tI68mdL1Tye19zpYy5L95lCu/xs5fHHIeItP/xo=";
  };

  build-system = [
    setuptools
    numpy
  ];

  dependencies = [ numpy ];

  preBuild = ''
    # Remove existing site.cfg, use the one we built for numpy
    ln -s ${numpy.cfg} site.cfg
  '';

  nativeCheckInputs = [ pytestCheckHook ];

  preCheck = ''
    pushd $out
  '';

  postCheck = ''
    popd
  '';

  disabledTests = [
    # fails on computers with more than 8 threads
    # https://github.com/pydata/numexpr/issues/479
    "test_numexpr_max_threads_empty_string"
    "test_omp_num_threads_empty_string"
  ];

  pythonImportsCheck = [ "numexpr" ];

  meta = with lib; {
    description = "Fast numerical array expression evaluator for NumPy";
    homepage = "https://github.com/pydata/numexpr";
    license = licenses.mit;
    maintainers = [ ];
  };
}
