{ lib
, buildPythonPackage
, fetchPypi
, setuptools-scm
, requests
, pyjwt
}:

buildPythonPackage rec {
  pname = "pyixapi";
  version = "0.2.3";
  format = "setuptools";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-qkgPBIYv9xzGa29RiPAU3zNhcyutTUX1Vkmpd9YdeJU=";
  };

  nativeBuildInputs = [
    setuptools-scm
  ];
  propagatedBuildInputs = [
    requests
    pyjwt
  ];

  pythonImportsCheck = [ "pyixapi" ];

  meta = with lib; {
    homepage = "https://github.com/peering-manager/pyixapi/";
    changelog = "https://github.com/peering-manager/pyixapi/releases/tag/${version}";
    description = "Python API client library for IX-API";
    license = licenses.asl20;
    maintainers = teams.wdz.members;
  };
}
