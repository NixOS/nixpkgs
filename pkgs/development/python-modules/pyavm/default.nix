{ lib
, buildPythonPackage
, fetchPypi
, pytestCheckHook
, astropy
, astropy-helpers
, pillow
}:

buildPythonPackage rec {
  pname = "pyavm";
  version = "0.9.6";

  src = fetchPypi {
    pname = "PyAVM";
    inherit version;
    hash = "sha256-s7eLPoAHDbY9tPt3RA5zJg+NuTtVV/SqpUUR3NrG8m0=";
  };

  propagatedBuildInputs = [
    astropy-helpers
  ];

  nativeCheckInputs = [
    astropy
    pillow
    pytestCheckHook
  ];

  # Disable automatic update of the astropy-helper module
  postPatch = ''
    substituteInPlace setup.cfg --replace "auto_use = True" "auto_use = False"
  '';

  pythonImportsCheck = [ "pyavm" ];

  meta = with lib; {
    description = "Simple pure-python AVM meta-data handling";
    homepage = "https://astrofrog.github.io/pyavm/";
    license = licenses.mit;
    maintainers = with maintainers; [ smaret ];
  };
}
