{ lib
, buildPythonPackage
, fetchPypi
}:

buildPythonPackage rec {
  version = "0.5.0";
  format = "setuptools";
  pname = "poyo";

  src = fetchPypi {
    inherit pname version;
    sha256 = "1pflivs6j22frz0v3dqxnvc8yb8fb52g11lqr88z0i8cg2m5csg2";
  };

  meta = with lib; {
    homepage = "https://github.com/hackebrot/poyo";
    description = "A lightweight YAML Parser for Python";
    license = licenses.mit;
  };

}
