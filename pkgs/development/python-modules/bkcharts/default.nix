{
  lib,
  buildPythonPackage,
  fetchPypi,
  numpy,
  pandas,
}:

buildPythonPackage rec {
  pname = "bkcharts";
  version = "0.2";
  format = "setuptools";

  src = fetchPypi {
    inherit version pname;
    hash = "sha256-peqo54hT3OyqRjRYEuT6vpzTuWMw6/CAn2QKSgVW1y4=";
  };

  propagatedBuildInputs = [
    numpy
    pandas
  ];

  # Circular test dependency on bokeh
  doCheck = false;

  meta = {
    description = "High level chart types built on top of Bokeh";
    homepage = "https://github.com/bokeh/bkcharts";
    license = lib.licenses.bsd3;
  };
}
