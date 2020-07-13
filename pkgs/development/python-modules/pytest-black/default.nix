{ lib, buildPythonPackage, fetchPypi
, black
, pytest
, setuptools_scm
, toml
}:

buildPythonPackage rec {
  pname = "pytest-black";
  version = "0.3.10";

  src = fetchPypi {
    inherit pname version;
    sha256 = "0dvlfic7nvfj97rg5fwj7ahw83n9yj3jjbp5m60n47mlx7z0qg2z";
  };

  nativeBuildInputs = [ setuptools_scm ];

  propagatedBuildInputs = [ black pytest toml ];

  pythonImportsCheck = [ "pytest_black" ];

  meta = with lib; {
    description = "A pytest plugin to enable format checking with black";
    homepage = "https://github.com/shopkeep/pytest-black";
    license = licenses.mit;
    maintainers = with maintainers; [ jonringer ];
  };
}
