{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  gitMinimal,
  numpy,
  packaging,
  pytest,
  pytestCheckHook,
  setuptools,
  setuptools-scm,
}:

buildPythonPackage rec {
  pname = "pytest-doctestplus";
  version = "1.7.1";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "scientific-python";
    repo = "pytest-doctestplus";
    tag = "v${version}";
    hash = "sha256-5vvLnvE0dvLYBNx34gsyQEcWlr7Cd063+rRjlnHM7OE=";
  };

  postPatch = ''
    substituteInPlace pytest_doctestplus/plugin.py \
      --replace-fail '"git"' '"${lib.getExe gitMinimal}"'
  '';

  build-system = [
    setuptools
    setuptools-scm
  ];

  buildInputs = [ pytest ];

  dependencies = [
    packaging
  ];

  pythonImportsCheck = [ "pytest_doctestplus" ];

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
    "test_remote_data_all"
  ];

  meta = {
    description = "Pytest plugin with advanced doctest features";
    homepage = "https://astropy.org";
    license = lib.licenses.bsd3;
    maintainers = [ ];
  };
}
