{
  lib,
  buildPythonPackage,
  fetchPypi,
  pythonOlder,
}:

buildPythonPackage rec {
  pname = "rcssmin";
  version = "1.2.1";
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-s1wMic2sj8NWwrCYXz5TToXMGNGXHZAtHqx/5rT/Vmw=";
  };

  # The package does not ship tests, and the setup machinery confuses
  # tests auto-discovery
  doCheck = false;

  pythonImportsCheck = [ "rcssmin" ];

  meta = with lib; {
    description = "CSS minifier written in pure python";
    homepage = "http://opensource.perlig.de/rcssmin/";
    license = licenses.asl20;
    maintainers = [ ];
  };
}
