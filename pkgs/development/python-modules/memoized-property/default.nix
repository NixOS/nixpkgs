{ python, stdenv, buildPythonPackage, fetchPypi }:

buildPythonPackage rec {
  version = "1.0.3";
  pname = "memoized-property";

  src = fetchPypi {
    inherit pname version;
    sha256 = "4be4d0209944b9b9b678dae9d7e312249fe2e6fb8bdc9bdaa1da4de324f0fcf5";
  };


  pythonImportsCheck = [ "memoized_property" ];

  meta = with stdenv.lib; {
    homepage = "https://github.com/estebistec/python-memoized-property";
    description = "A simple python decorator for defining properties that only run their fget function once ";
    license = licenses.bsd3;
    maintainers = [ maintainers.moritzs ];
  };
}
