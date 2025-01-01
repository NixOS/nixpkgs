{
  lib,
  buildPythonPackage,
  dos2unix,
  fetchPypi,
  fetchpatch2,
  numpy,
  pytestCheckHook,
  setuptools,
}:

buildPythonPackage rec {
  pname = "numexpr";
  version = "2.10.1";
  pyproject = true;

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-m7qZ01SmXxoAiri4fwfYRATGaOZrq2JN9ba1NzQDz4E=";
  };

  patches = [
    (fetchpatch2 {
      # https://github.com/pydata/numexpr/pull/491
      name = "fix-test.patch";
      url = "https://github.com/pydata/numexpr/commit/2c7bb85e117147570db5619ed299497a42af9f54.patch";
      hash = "sha256-cv2logZ8dKeWNB5+bPmPfpfiWaV7k8+2sE9lZa+dUsA=";
    })
  ];

  prePatch = ''
    dos2unix numexpr/tests/test_numexpr.py
  '';

  nativeBuildInputs = [ dos2unix ];

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
