{ lib
, buildPythonPackage
, fetchPypi
}:

buildPythonPackage rec {
  pname = "pylutron";
  version = "0.2.7";

  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-wwVTDpoRT/TIJhoRap0T01a8gmYt+vfKc+ATRs6phB4=";
  };

  # Project has no tests
  doCheck = false;
  pythonImportsCheck = [ "pylutron" ];

  meta = with lib; {
    description = "Python library for controlling a Lutron RadioRA 2 system";
    homepage = "https://github.com/thecynic/pylutron";
    license = with licenses; [ mit ];
    maintainers = with maintainers; [ fab ];
  };
}
