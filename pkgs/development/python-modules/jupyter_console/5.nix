{ lib
, buildPythonPackage
, fetchPypi
, nose
, jupyter_client
, ipython
, ipykernel
, prompt_toolkit
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
    jupyter_client
    ipython
    ipykernel
    prompt_toolkit
    pygments
  ];

  # ValueError: underlying buffer has been detached
  doCheck = false;

  meta = {
    description = "Jupyter terminal console";
    homepage = "http://jupyter.org/";
    license = lib.licenses.bsd3;
  };
}
