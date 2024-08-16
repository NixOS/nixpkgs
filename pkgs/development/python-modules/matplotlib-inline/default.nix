{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  pythonOlder,
  setuptools,
  traitlets,

  # tests
  ipython,
}:

buildPythonPackage rec {
  pname = "matplotlib-inline";
  version = "0.1.7";
  pyproject = true;

  disabled = pythonOlder "3.8";

  src = fetchFromGitHub {
    owner = "ipython";
    repo = "matplotlib-inline";
    rev = "refs/tags/${version}";
    hash = "sha256-y7T8BshNa8NVWzH8oLS4dTAyhG+YmkkYQJFAyMXsJFA=";
  };

  build-system = [ setuptools ];

  dependencies = [ traitlets ];

  # wants to import ipython, which creates a circular dependency
  doCheck = false;

  #
  pythonImportsCheck = [
    # tries to import matplotlib, which can't work with doCheck disabled
    #"matplotlib_inline"
  ];

  passthru.tests = {
    inherit ipython;
  };

  meta = with lib; {
    description = "Matplotlib Inline Back-end for IPython and Jupyter";
    homepage = "https://github.com/ipython/matplotlib-inline";
    license = licenses.bsd3;
    maintainers = [ ];
  };
}
