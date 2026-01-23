{
  lib,
  buildPythonPackage,
  fetchPypi,
  numpy,
}:

buildPythonPackage rec {
  pname = "fastprogress";
  version = "1.0.5";
  format = "setuptools";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-WMoWqYHwKSgE2QXy4AQq1gjXiL9svmq5a3HsSyBFOu8=";
  };

  propagatedBuildInputs = [ numpy ];

  # no real tests
  doCheck = false;
  pythonImportsCheck = [ "fastprogress" ];

  meta = {
    homepage = "https://github.com/fastai/fastprogress";
    description = "Simple and flexible progress bar for Jupyter Notebook and console";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ ris ];
  };
}
