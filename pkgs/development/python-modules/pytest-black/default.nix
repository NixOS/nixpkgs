{ lib, buildPythonPackage, fetchPypi
, black
, pytest
, setuptools_scm
, toml
}:

buildPythonPackage rec {
  pname = "pytest-black";
  version = "0.3.12";

  src = fetchPypi {
    inherit pname version;
    sha256 = "1d339b004f764d6cd0f06e690f6dd748df3d62e6fe1a692d6a5500ac2c5b75a5";
  };

  nativeBuildInputs = [ setuptools_scm ];

  propagatedBuildInputs = [ black pytest toml ];

  # does not contain tests
  doCheck = false;
  pythonImportsCheck = [ "pytest_black" ];

  meta = with lib; {
    description = "A pytest plugin to enable format checking with black";
    homepage = "https://github.com/shopkeep/pytest-black";
    license = licenses.mit;
    maintainers = with maintainers; [ jonringer ];
  };
}
