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
  version = "unstable-2022-02-17";
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "matthewwithanm";
    repo = pname;
    rev = "09ffa2ad33318ae5fd3464655c14c7f01ffc2097";
    hash = "sha256-jtnFffKr0yhSv2jBmXzPa6iP2r41MbmGukfmnvgABhk=";
  };

  buildInputs = [
    pillow
  ];

  nativeCheckInputs = [
    mock
    pytestCheckHook
  ];

  postPatch = ''
    substituteInPlace tox.ini \
      --replace " --cov --cov-report term-missing:skip-covered" ""
  '';

  pythonImportsCheck = [
    "pilkit"
  ];

  meta = with lib; {
    description = "A collection of utilities and processors for the Python Imaging Libary";
    homepage = "https://github.com/matthewwithanm/pilkit/";
    license = licenses.bsd0;
    maintainers = with maintainers; [ domenkozar ];
  };
}
