{
  lib,
  buildPythonPackage,
  fetchPypi,
  numpy,
  pytestCheckHook,
  setuptools,
  wheel,
}:

buildPythonPackage rec {
  pname = "numexpr";
  version = "2.10.0";
  pyproject = true;

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-yJ6TB1JjnfBAU5FgMm2PmahBWbvqQZQ6uOlgWR7arvA=";
  };

  # patch for compatibility with numpy < 2.0
  # see more details, https://numpy.org/devdocs/numpy_2_0_migration_guide.html#c-api-changes
  postPatch = ''
    substituteInPlace pyproject.toml \
      --replace-fail "numpy>=2.0.0rc1" "numpy"
    sed -i "1i#define PyDataType_SET_ELSIZE(descr, elsize)" numexpr/interpreter.cpp
    sed -i "1i#define PyDataType_ELSIZE(descr) ((descr)->elsize)" numexpr/interpreter.cpp
  '';

  build-system = [
    setuptools
    wheel
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
