{ lib
, buildPythonPackage
, fetchFromGitHub
, matplotlib
, palettable
, pandas
, pytestCheckHook
, pythonOlder
, scipy
}:

buildPythonPackage rec {
  pname = "mizani";
  version = "0.8.1";
  format = "setuptools";

  disabled = pythonOlder "3.8";

  src = fetchFromGitHub {
    owner = "has2k1";
    repo = pname;
    rev = "refs/tags/v${version}";
    hash = "sha256-VE0M5/s8/XmmAe8EE/FcHBFGc9ppVWuYOYMuajQeZww=";
  };

  propagatedBuildInputs = [
    matplotlib
    palettable
    pandas
    scipy
  ];

  checkInputs = [
    pytestCheckHook
  ];

  postPatch = ''
    substituteInPlace pytest.ini \
      --replace " --cov=mizani --cov-report=xml" ""
  '';

  pythonImportsCheck = [
    "mizani"
  ];

  meta = with lib; {
    description = "Scales for Python";
    homepage = "https://github.com/has2k1/mizani";
    license = licenses.bsd3;
    maintainers = with maintainers; [ samuela ];
  };
}
