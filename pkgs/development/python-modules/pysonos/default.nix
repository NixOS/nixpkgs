{ lib
, buildPythonPackage
, fetchPypi
, xmltodict
, requests
, ifaddr
}:

buildPythonPackage rec {
  pname = "pysonos";
  version = "0.0.11";

  src = fetchPypi {
    inherit pname version;
    sha256 = "145pw02fkzlff13djkl51z6m3dfn46wf0qwn035di69vm9bzvbl9";
  };

  propagatedBuildInputs = [ xmltodict requests ifaddr ];

  # Need to override pytest-conv to an old version
  doCheck = false;

  meta = {
    homepage = https://github.com/amelchio/pysonos;
    description = "A SoCo fork with fixes for Home Assistant.";
    license = lib.licenses.mit;
  };
}
