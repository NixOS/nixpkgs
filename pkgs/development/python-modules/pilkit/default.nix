{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  mock,
  pillow,
  pytestCheckHook,
  pytest-cov-stub,
  pythonOlder,
  setuptools,
}:

buildPythonPackage rec {
  pname = "pilkit";
  version = "3.0";
  pyproject = true;

  disabled = pythonOlder "3.7";

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

  meta = with lib; {
    description = "Collection of utilities and processors for the Python Imaging Library";
    homepage = "https://github.com/matthewwithanm/pilkit/";
    license = licenses.bsd3;
    maintainers = with maintainers; [ ];
  };
}
