{
  lib,
  buildPythonPackage,
  fetchPypi,
  plaster,
  pastedeploy,
  pytestCheckHook,
}:

buildPythonPackage rec {
  pname = "plaster-pastedeploy";
  version = "1.0.1";
  format = "setuptools";

  src = fetchPypi {
    pname = "plaster_pastedeploy";
    inherit version;
    hash = "sha256-viYubS5BpyZIddqi/ihQy7BhVyi83JKCj9xyc244FBI=";
  };

  propagatedBuildInputs = [
    plaster
    pastedeploy
  ];

  nativeCheckInputs = [ pytestCheckHook ];

  meta = with lib; {
    description = "PasteDeploy binding to the plaster configuration loader";
    homepage = "https://github.com/Pylons/plaster_pastedeploy";
    license = licenses.mit;
    maintainers = with maintainers; [ ];
  };
}
