{ lib
, buildPythonPackage
, fetchFromGitHub
, matplotlib
, numpy
, pandas
}:

buildPythonPackage rec {
  pname = "calplot";
  version = "0.1.7.5";
  format = "setuptools";

  src = fetchFromGitHub {
    owner = "tomkwok";
    repo = "calplot";
    rev = version;
    hash = "sha256-+S7LwXNSQqpqwsoQ82hX+7ndKqN/ZfYrCOQuCnqmZP0=";
  };

  propagatedBuildInputs = [
    matplotlib
    numpy
    pandas
  ];

  # has no tests
  doCheck = false;

  pythonImportsCheck = [ "calplot" ];

  meta = with lib; {
    description = "Calendar heatmaps from Pandas time series data";
    homepage = "https://github.com/tomkwok/calplot";
    changelog = "https://github.com/tomkwok/calplot/blob/${src.rev}/CHANGES.rst";
    license = licenses.mit;
    maintainers = with maintainers; [ SuperSandro2000 ];
  };
}
