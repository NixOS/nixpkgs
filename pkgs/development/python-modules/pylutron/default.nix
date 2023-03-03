{ lib
, buildPythonPackage
, fetchPypi
}:

buildPythonPackage rec {
  pname = "pylutron";
  version = "0.2.10";

  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-DKwjBQXC7O/8bFxq5shJJxRV3HYgBeS7tJXg4m3vQMY=";
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
