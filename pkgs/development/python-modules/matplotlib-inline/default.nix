{ lib, buildPythonPackage, fetchPypi
, traitlets

# tests
, ipython
}:

buildPythonPackage rec {
  pname = "matplotlib-inline";
  version = "0.1.3";

  src = fetchPypi {
    inherit pname version;
    sha256 = "a04bfba22e0d1395479f866853ec1ee28eea1485c1d69a6faf00dc3e24ff34ee";
  };

  propagatedBuildInputs = [
    traitlets
  ];

  # wants to import ipython, which creates a circular dependency
  doCheck = false;
  pythonImportsCheck = [ "matplotlib_inline" ];

  passthru.tests = { inherit ipython; };

  meta = with lib; {
    description = "Matplotlib Inline Back-end for IPython and Jupyter";
    homepage = "https://github.com/ipython/matplotlib-inline";
    license = licenses.bsd3;
    maintainers = with maintainers; [ jonringer ];
  };
}
