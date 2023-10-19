{ lib, buildPythonPackage, fetchPypi
, traitlets

# tests
, ipython
}:

buildPythonPackage rec {
  pname = "matplotlib-inline";
  version = "0.1.6";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-+Ifl8Qupjo0rFQ3c9HAsHl+LOiAAXrD3S/29Ng7m8wQ=";
  };

  propagatedBuildInputs = [
    traitlets
  ];

  # wants to import ipython, which creates a circular dependency
  doCheck = false;

  #
  pythonImportsCheck = [
    # tries to import matplotlib, which can't work with doCheck disabled
    #"matplotlib_inline"
  ];

  passthru.tests = { inherit ipython; };

  meta = with lib; {
    description = "Matplotlib Inline Back-end for IPython and Jupyter";
    homepage = "https://github.com/ipython/matplotlib-inline";
    license = licenses.bsd3;
    maintainers = with maintainers; [ jonringer ];
  };
}
