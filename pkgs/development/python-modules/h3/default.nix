{ lib
, stdenv
, buildPythonPackage
, fetchPypi
, h3
, scikit-build
, cmake
, numpy
, cython
, pytestCheckHook
}:

buildPythonPackage rec {
  pname = "h3";
  version = "3.7.1";
  format = "pyproject";

  src = fetchPypi {
    inherit pname version;
    sha256 = "16pa023rdrw5iylky0y1mycz8pkfdwchr531w7grpyn0n06ym5w0";
  };

  nativeBuildInputs = [ scikit-build cmake cython ];
  propagatedBuildInputs = [ numpy ];

  dontConfigure = true;

  checkInputs = [ pytestCheckHook ];
  pythonImportsCheck = [ "h3" ];

  meta = with lib; {
    homepage = "https://github.com/uber/h3-py";
    description = "Hierarchical hexagonal geospatial indexing system";
    license = licenses.asl20;
    maintainers = [ maintainers.kalbasit ];
  };
}
