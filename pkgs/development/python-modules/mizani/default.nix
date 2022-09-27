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
  version = "0.8.0";
  format = "setuptools";

  disabled = pythonOlder "3.8";

  src = fetchFromGitHub {
    owner = "has2k1";
    repo = pname;
    rev = "refs/tags/v${version}";
    hash = "sha256-MgF+w4guxx9wBNDjMXMYFWfKr7Mwjadcpg5JzSbgm1Y=";
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
