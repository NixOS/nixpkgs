{ buildPythonPackage
, numpy
, matplotlib
, fetchFromGitHub
, lib
}:

buildPythonPackage rec {
  pname = "adjusttext";
  version = "0.7.3";

  src = fetchFromGitHub {
    owner = "Phlya";
    repo = pname;
    rev = version;
    sha256 = "02apaznnnmwmrn342f22dj5dldn56gdl9v5qix07ah6kgp9503yw";
  };

  propagatedBuildInputs = [ matplotlib numpy ];

  # Project has no tests
  doCheck = false;

  pythonImportsCheck = [ "adjustText" ];

  meta = with lib; {
    description = "Iteratively adjust text position in matplotlib plots to minimize overlaps";
    homepage = "https://github.com/Phlya/adjustText";
    license = licenses.mit;
    maintainers = with maintainers; [ samuela ];
  };
}
