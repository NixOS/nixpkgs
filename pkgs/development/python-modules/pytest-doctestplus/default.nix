{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
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
  version = "1.4.0";
  pyproject = true;

  disabled = pythonOlder "3.8";

  src = fetchFromGitHub {
    owner = "scientific-python";
    repo = "pytest-doctestplus";
    tag = "v${version}";
    hash = "sha256-hKxTniN7BHDdIHqxNGOuvD7Rk5ChSh1Zn6fo6G+Uty4=";
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

  meta = with lib; {
    description = "Pytest plugin with advanced doctest features";
    homepage = "https://astropy.org";
    license = licenses.bsd3;
    maintainers = [ ];
  };
}
