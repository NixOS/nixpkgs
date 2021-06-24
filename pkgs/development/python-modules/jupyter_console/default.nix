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
  version = "6.3.0";
  disabled = pythonOlder "3.5";

  src = fetchPypi {
    inherit pname version;
    sha256 = "947f66bbdeee2221b4fb3a6b78225d337b8f10832f14cecf7932183635abe1d9";
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
