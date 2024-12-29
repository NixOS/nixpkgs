{
  lib,
  fetchPypi,
  buildPythonPackage,
  psutil,
  pytest,
}:

buildPythonPackage rec {
  pname = "pyprind";
  version = "2.11.3";

  src = fetchPypi {
    pname = "PyPrind";
    inherit version;
    sha256 = "e37dcab6e1a9c8e0a7f0fce65fde7a79e2deda1c75aa015910a49e2137b54cbf";
  };

  buildInputs = [ psutil ];

  nativeCheckInputs = [ pytest ];

  checkPhase = ''
    py.test tests
  '';

  meta = with lib; {
    description = "Python Progress Bar and Percent Indicator Utility";
    homepage = "https://github.com/rasbt/pyprind";
    license = licenses.bsd3;
    maintainers = with maintainers; [ ];
  };
}
