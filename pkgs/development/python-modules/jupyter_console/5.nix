{ lib
, buildPythonPackage
, fetchPypi
, nose
, jupyter-client
, ipython
, ipykernel
, prompt-toolkit
, pygments
}:

buildPythonPackage rec {
  pname = "jupyter_console";
  version = "5.2.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "545dedd3aaaa355148093c5609f0229aeb121b4852995c2accfa64fe3e0e55cd";
  };

  checkInputs = [ nose ];
  propagatedBuildInputs = [
    jupyter-client
    ipython
    ipykernel
    prompt-toolkit
    pygments
  ];

  # ValueError: underlying buffer has been detached
  doCheck = false;

  meta = {
    description = "Jupyter terminal console";
    homepage = "https://jupyter.org/";
    license = lib.licenses.bsd3;
  };
}
