{ lib
, buildPythonPackage
, fetchPypi
, nose
, isPy27
, mock
, ipython
, jupyter_client
, pexpect
, traitlets
, tornado
}:

buildPythonPackage rec {
  pname = "ipykernel";
  version = "4.8.2";
  name = "${pname}-${version}";

  src = fetchPypi {
    inherit pname version;
    sha256 = "c091449dd0fad7710ddd9c4a06e8b9e15277da306590bc07a3a1afa6b4453c8f";
  };

  buildInputs = [ nose ] ++ lib.optional isPy27 mock;
  propagatedBuildInputs = [
    ipython
    jupyter_client
    pexpect
    traitlets
    tornado
  ];

  # Tests require backends.
  # I don't want to add all supported backends as propagatedBuildInputs
  doCheck = false;

  meta = {
    description = "IPython Kernel for Jupyter";
    homepage = http://ipython.org/;
    license = lib.licenses.bsd3;
    maintainers = with lib.maintainers; [ fridh ];
  };
}