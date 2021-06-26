{ lib, buildPythonPackage, fetchPypi
, matplotlib
, traitlets

# tests
, ipython
}:

buildPythonPackage rec {
  pname = "matplotlib-inline";
  version = "0.1.2";

  src = fetchPypi {
    inherit pname version;
    sha256 = "0glrhcv1zqck1whsh3p75x0chda588xw22swbmvqalwz7kvmy7gl";
  };

  propagatedBuildInputs = [
    matplotlib # not documented, but required
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
