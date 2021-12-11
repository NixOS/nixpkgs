{ lib
, buildPythonPackage
, fetchFromGitHub
, nose
, cython
, numpy
}:

buildPythonPackage rec {
  version = "0.14.2";
  pname = "hdmedians";

  src = fetchFromGitHub {
     owner = "daleroberts";
     repo = "hdmedians";
     rev = "v0.14.2";
     sha256 = "033lszvdgcv47zyc6azy21w7adn37gk717yv006xwl81kkhdrhkq";
  };

  # nose was specified in setup.py as a build dependency...
  buildInputs = [ cython nose ];
  propagatedBuildInputs = [ numpy ];

  # cannot resolve path for packages in tests
  doCheck = false;

  checkPhase = ''
    nosetests
  '';

  meta = with lib; {
    homepage = "https://github.com/daleroberts/hdmedians";
    description = "High-dimensional medians";
    license = licenses.gpl3;
    maintainers = [ maintainers.costrouc ];
  };
}
