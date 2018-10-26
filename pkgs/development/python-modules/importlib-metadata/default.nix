{ buildPythonPackage
, fetchPypi
, lib
, recursivePthLoader
, isPy3k
}:

buildPythonPackage rec {
  pname = "importlib_metadata";
  version = "0.6";
  name = "importlib_metadata";

  disabled = !isPy3k;

  src = fetchPypi {
    inherit pname version;
    sha256 = "074v6mq5dbbr0y697fgajm503sg83faxzvwz41jxy6h0z622rc1n";
  };

  pythonPath = [ recursivePthLoader ];

  doCheck = false;
  propagatedBuildInputs = [ ];

  meta = {
    description = "Read metadata from Python packages";
    homepage = https://gitlab.com/python-devs/importlib_metadata;
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ jfroche ];
  };
}
