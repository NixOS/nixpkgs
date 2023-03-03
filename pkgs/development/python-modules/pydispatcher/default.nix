{ lib
, buildPythonPackage
, fetchPypi
, pytestCheckHook
}:

buildPythonPackage rec {
  version = "2.0.6";
  pname = "pydispatcher";

  src = fetchPypi {
    pname = "PyDispatcher";
    inherit version;
    hash = "sha256-PX5PQ8cAAKHcox+SaU6Z0BAZNPpuq11UVadYhY2G35U=";
  };

  nativeCheckInputs = [
    pytestCheckHook
  ];

  meta = with lib; {
    homepage = "https://pydispatcher.sourceforge.net/";
    description = "Signal-registration and routing infrastructure for use in multiple contexts";
    license = licenses.bsd3;
  };

}
