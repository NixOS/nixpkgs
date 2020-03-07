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
  version = "6.1.0";
  disabled = pythonOlder "3.5";

  src = fetchPypi {
    inherit pname version;
    sha256 = "06s3kr5vx0l1y1b7fxb04dmrppscl7q69sl9yyfr0d057d1ssvkg";
  };

  propagatedBuildInputs = [
    jupyter_client
    ipython
    ipykernel
    prompt_toolkit
    pygments
  ];
  checkInputs = [ nose ];

  postPatch = ''
    substituteInPlace setup.py \
      --replace "prompt_toolkit>=2.0.0,<2.1.0" "prompt_toolkit"
  '';

  # ValueError: underlying buffer has been detached
  doCheck = false;

  meta = {
    description = "Jupyter terminal console";
    homepage = "https://jupyter.org/";
    license = lib.licenses.bsd3;
  };
}
