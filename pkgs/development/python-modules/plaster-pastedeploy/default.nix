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

<<<<<<< HEAD
  meta = {
    description = "PasteDeploy binding to the plaster configuration loader";
    homepage = "https://github.com/Pylons/plaster_pastedeploy";
    license = lib.licenses.mit;
=======
  meta = with lib; {
    description = "PasteDeploy binding to the plaster configuration loader";
    homepage = "https://github.com/Pylons/plaster_pastedeploy";
    license = licenses.mit;
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
    maintainers = [ ];
  };
}
