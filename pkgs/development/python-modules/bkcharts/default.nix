{ lib
, buildPythonPackage
, fetchFromGitHub
, numpy
, pandas
}:


buildPythonPackage rec {
  pname = "bkcharts";
  version = "0.2";

  src = fetchFromGitHub {
     owner = "bokeh";
     repo = "bkcharts";
     rev = "0.2";
     sha256 = "0yzdsaackpnfhiy0jhkhhmysiaj695140dl6pz99c6vcpwd89q5v";
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
