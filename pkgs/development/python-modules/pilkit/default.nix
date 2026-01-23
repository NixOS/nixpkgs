{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  mock,
  pillow,
  pytestCheckHook,
  pytest-cov-stub,
  setuptools,
}:

buildPythonPackage rec {
  pname = "pilkit";
  version = "3.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "matthewwithanm";
    repo = "pilkit";
    tag = version;
    hash = "sha256-NmD9PFCkz3lz4AnGoQUpkt35q0zvDVm+kx7lVDFBcHk=";
  };

  nativeBuildInputs = [ setuptools ];

  propagatedBuildInputs = [ pillow ];

  nativeCheckInputs = [
    mock
    pytestCheckHook
    pytest-cov-stub
  ];

  postPatch = ''
    substituteInPlace pilkit/processors/resize.py \
      --replace "Image.ANTIALIAS" "Image.Resampling.LANCZOS"
  '';

  pythonImportsCheck = [ "pilkit" ];

  meta = {
    description = "Collection of utilities and processors for the Python Imaging Library";
    homepage = "https://github.com/matthewwithanm/pilkit/";
    license = lib.licenses.bsd3;
    maintainers = [ ];
  };
}
