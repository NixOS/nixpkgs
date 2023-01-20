{ lib
, buildPythonPackage
, fetchPypi
, twisted
}:

buildPythonPackage rec {
  pname = "pymeta3";
  version = "0.5.1";
  format = "setuptools";

  src = fetchPypi {
    pname = "PyMeta3";
    inherit version;
    hash = "sha256-GL2jJtmpu/WHv8DuC8loZJZNeLBnKIvPVdTZhoHQW8s=";
  };

  pythonImportsCheck = [ "pymeta" ];

  checkInputs = [ twisted ];

  # Tests broken on Python 3 (upstream bugs)
  doCheck = false;

  meta = with lib; {
    description = "A Pattern-Matching Language Based on Python";
    homepage = "https://github.com/wbond/pymeta3";
    license = licenses.mit;
    maintainers = with maintainers; [ tmarkus ];
  };
}
