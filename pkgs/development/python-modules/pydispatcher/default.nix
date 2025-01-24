{
  lib,
  buildPythonPackage,
  fetchPypi,
  pytestCheckHook,
}:

buildPythonPackage rec {
  version = "2.0.7";
  format = "setuptools";
  pname = "pydispatcher";

  src = fetchPypi {
    pname = "PyDispatcher";
    inherit version;
    hash = "sha256-t3fGrQgNwbrXSkwp1qRpFPpnAaxw+UsNZvvP3mL1vjE=";
  };

  nativeCheckInputs = [ pytestCheckHook ];

  meta = with lib; {
    homepage = "https://pydispatcher.sourceforge.net/";
    description = "Signal-registration and routing infrastructure for use in multiple contexts";
    license = licenses.bsd3;
  };
}
