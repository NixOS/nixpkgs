{ lib
, buildPythonPackage
, fetchPypi
, nose
, jupyter_client
, ipython
, ipykernel
, prompt_toolkit
, pygments
, pythonOlder
}:

buildPythonPackage rec {
  pname = "jupyter_console";
  version = "6.0.0";
  disabled = pythonOlder "3.5";

  src = fetchPypi {
    inherit pname version;
    sha256 = "308ce876354924fb6c540b41d5d6d08acfc946984bf0c97777c1ddcb42e0b2f5";
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
    homepage = "https://jupyter.org/";
    license = lib.licenses.bsd3;
  };
}
