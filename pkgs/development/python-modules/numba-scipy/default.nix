{ stdenv
, lib
, buildPythonPackage
, fetchPypi
, scipy
, numba
, pytestCheckHook
}:

buildPythonPackage rec {
  pname = "numba-scipy";
  version = "0.3.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-qJeoWiG1LdtFB9cME1d8xVaC0BXGDJEYjCOEdHvSkmQ=";
  };

  propagatedBuildInputs = [
    scipy
    numba
  ];

  postPatch = ''
    substituteInPlace setup.py --replace "scipy>=0.16,<=1.6.2" "scipy>=0.16,<=1.7.3"
  '';

  checkInputs = [
    pytestCheckHook
  ];

  pythonImportsCheck = [ "numba" ];

  meta = with lib; {
    broken = stdenv.isDarwin;
    description = "Extends Numba to make it aware of SciPy";
    homepage = "https://github.com/numba/numba-scipy";
    changelog = "https://github.com/numba/numba-scipy/blob/master/CHANGE_LOG";
    license = licenses.bsd2;
    maintainers = with maintainers; [ Etjean ];
  };
}
