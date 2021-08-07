{ lib, fetchPypi, isPy27
, buildPythonPackage
, traits, apptools, pytestCheckHook
, ipykernel, ipython, setuptools
}:

buildPythonPackage rec {
  pname = "envisage";
  version = "5.0.0";

  disabled = isPy27;

  src = fetchPypi {
    inherit pname version;
    sha256 = "0zrxlq4v3091727vf10ngc8418sp26raxa8q83i4h0sydfkh2dic";
  };

  propagatedBuildInputs = [ traits apptools setuptools ];

  preCheck = ''
    export HOME=$PWD/HOME
  '';

  checkInputs = [
    ipykernel ipython pytestCheckHook
  ];

  meta = with lib; {
    description = "Framework for building applications whose functionalities can be extended by adding 'plug-ins'";
    homepage = "https://github.com/enthought/envisage";
    maintainers = with lib.maintainers; [ knedlsepp ];
    license = licenses.bsdOriginal;
  };
}
