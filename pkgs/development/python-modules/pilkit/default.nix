{ lib
, buildPythonPackage
, fetchFromGitHub
, mock
, pillow
, pytestCheckHook
, pythonOlder
}:

buildPythonPackage rec {
  pname = "pilkit";
  version = "3.0";
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "matthewwithanm";
    repo = pname;
    rev = "refs/tags/${version}";
    hash = "sha256-NmD9PFCkz3lz4AnGoQUpkt35q0zvDVm+kx7lVDFBcHk=";
  };

  propagatedBuildInputs = [
    pillow
  ];

  nativeCheckInputs = [
    mock
    pytestCheckHook
  ];

  postPatch = ''
    substituteInPlace tox.ini \
      --replace " --cov --cov-report term-missing:skip-covered" ""
    substituteInPlace pilkit/processors/resize.py \
      --replace "Image.ANTIALIAS" "Image.Resampling.LANCZOS"
  '';

  pythonImportsCheck = [
    "pilkit"
  ];

  meta = with lib; {
    description = "A collection of utilities and processors for the Python Imaging Library";
    homepage = "https://github.com/matthewwithanm/pilkit/";
    license = licenses.bsd0;
    maintainers = with maintainers; [ domenkozar ];
  };
}
