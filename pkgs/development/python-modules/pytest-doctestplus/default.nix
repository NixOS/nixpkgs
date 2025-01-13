{
  lib,
  buildPythonPackage,
  fetchPypi,
  gitMinimal,
  numpy,
  packaging,
  pytest,
  pytestCheckHook,
  pythonOlder,
  setuptools,
  setuptools-scm,
}:

buildPythonPackage rec {
  pname = "pytest-doctestplus";
  version = "1.3.0";
  pyproject = true;

  disabled = pythonOlder "3.9";

  src = fetchPypi {
    pname = "pytest_doctestplus";
    inherit version;
    hash = "sha256-cJrSPqmNqag1rOCkNlyFNxw3bgAPKGDzDebfOm8Acoo=";
  };

  postPatch = ''
    substituteInPlace pytest_doctestplus/plugin.py \
      --replace-fail '"git"' '"${lib.getExe gitMinimal}"'
  '';

  build-system = [ setuptools-scm ];

  buildInputs = [ pytest ];

  dependencies = [
    packaging
    setuptools
  ];

  nativeCheckInputs = [
    numpy
    pytestCheckHook
  ];

  disabledTests = [
    # ERROR: usage: __main__.py [options] [file_or_dir] [file_or_dir] [...]
    # __main__.py: error: unrecognized arguments: --remote-data
    "test_remote_data_url"
    "test_remote_data_float_cmp"
    "test_remote_data_ignore_whitespace"
    "test_remote_data_ellipsis"
    "test_remote_data_requires"
    "test_remote_data_ignore_warnings"
  ];

  meta = with lib; {
    description = "Pytest plugin with advanced doctest features";
    homepage = "https://github.com/scientific-python/pytest-doctestplus";
    changelog = "https://github.com/scientific-python/pytest-doctestplus/releases/tag/v${version}";
    license = licenses.bsd3;
    maintainers = [ ];
  };
}
