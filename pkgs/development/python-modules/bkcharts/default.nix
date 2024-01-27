{ lib
, buildPythonPackage
, fetchPypi
, numpy
, pandas
}:


buildPythonPackage rec {
  pname = "bkcharts";
  version = "0.2";
  format = "setuptools";

  src = fetchPypi {
    inherit version pname;
    sha256 = "a5eaa8e78853dcecaa46345812e4fabe9cd3b96330ebf0809f640a4a0556d72e";
  };

  propagatedBuildInputs = [ numpy pandas ];

  # Circular test dependency on bokeh
  doCheck = false;

  meta = {
    description = "High level chart types built on top of Bokeh";
    homepage = "https://github.com/bokeh/bkcharts";
    license = lib.licenses.bsd3;
  };
}
