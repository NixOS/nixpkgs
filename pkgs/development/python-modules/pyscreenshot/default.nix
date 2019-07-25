{ lib
, buildPythonPackage
, fetchPypi
, EasyProcess
}:

buildPythonPackage rec {
  pname = "pyscreenshot";
  version = "0.5.1";

  src = fetchPypi {
    inherit pname version;
    sha256 = "19ec6d17a61c0cd4e7fcf3ab2685598a54b53dc781755393cc5f76dcb7bf359c";
  };

  propagatedBuildInputs = [
    EasyProcess
  ];

  # recursive dependency on pyvirtualdisplay
  doCheck = false;

  meta = with lib; {
    description = "python screenshot";
    homepage = "https://github.com/ponty/pyscreenshot";
    license = licenses.bsd3;
    maintainers = with maintainers; [ costrouc ];
  };
}
