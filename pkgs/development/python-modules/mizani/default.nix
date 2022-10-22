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
  version = "0.7.4";
  format = "setuptools";

  disabled = pythonOlder "3.8";

  src = fetchFromGitHub {
    owner = "has2k1";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-oqbo/aQ5L1nQO8BvXH6/8PBPiWcv2m/LUjwow8+J90w=";
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
