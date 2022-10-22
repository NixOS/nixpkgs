{ lib
, buildPythonPackage
, fetchFromGitHub
, matplotlib
, numpy
, packaging
}:

buildPythonPackage rec {
  pname = "adjusttext";
  version = "0.7.3.1";
  format = "setuptools";

  src = fetchFromGitHub {
    owner = "Phlya";
    repo = pname;
    rev = version;
    sha256 = "1a6hizx1cnplj0irn8idgda2lacsb61dw464cwx798pjr1gd401n";
  };

  nativeBuildInputs = [
    packaging
  ];

  propagatedBuildInputs = [
    matplotlib
    numpy
  ];

  # Project has no tests
  doCheck = false;

  pythonImportsCheck = [
    "adjustText"
  ];

  meta = with lib; {
    description = "Iteratively adjust text position in matplotlib plots to minimize overlaps";
    homepage = "https://github.com/Phlya/adjustText";
    license = licenses.mit;
    maintainers = with maintainers; [ samuela ];
  };
}
