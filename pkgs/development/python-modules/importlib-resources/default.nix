{ buildPythonPackage
, fetchPypi
, lib
, recursivePthLoader
, isPy3k
}:

buildPythonPackage rec {
  pname = "importlib_resources";
  version = "1.0.1";
  name = "importlib_resources";

  src = fetchPypi {
    inherit pname version;
    sha256 = "1yrf2nyrxigi3f6h4kj7sqxzb4dwkqgqrcb2saprn55ccbh59x3k";
  };

  disabled = !isPy3k;

  pythonPath = [ recursivePthLoader ];
  doCheck = false;
  propagatedBuildInputs = [ ];

  meta = {
    description = "Read resources from Python packages";
    homepage = https://gitlab.com/python-devs/importlib_resources;
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ jfroche ];
  };
}
