{ lib
, buildPythonPackage
, fetchPypi
, docopt
, colorama
, pytest
, watchdog
}:

buildPythonPackage rec {
  pname = "pytest-watch";
  version = "4.2.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "06136f03d5b361718b8d0d234042f7b2f203910d8568f63df2f866b547b3d4b9";
  };

  # No Tests
  doCheck = false;

  propagatedBuildInputs = [ pytest colorama docopt watchdog ];

  meta = with lib; {
    homepage = "https://github.com/joeyespo/pytest-watch";
    description = "Local continuous test runner with pytest and watchdog";
    license = licenses.mit;
    maintainers = with maintainers; [ dmvianna ];
  };
}

