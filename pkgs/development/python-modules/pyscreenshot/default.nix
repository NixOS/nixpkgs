{ lib
, buildPythonPackage
, fetchPypi
, isPy3k
, EasyProcess
, entrypoint2
, jeepney
, mss
, pillow
}:

buildPythonPackage rec {
  pname = "pyscreenshot";
  version = "2.3";

  src = fetchPypi {
    inherit pname version;
    sha256 = "bfdc311bd6ec1ee9e3c25ece75b24a749673ad5d5f89ee02950080023054ffd5";
  };

  propagatedBuildInputs = [
    EasyProcess
    entrypoint2
    pillow
  ] ++ lib.optionals (isPy3k) [
    jeepney
    mss
  ];

  # recursive dependency on pyvirtualdisplay
  doCheck = false;

  pythonImportsCheck = [ "pyscreenshot" ];

  meta = with lib; {
    description = "python screenshot";
    homepage = "https://github.com/ponty/pyscreenshot";
    license = licenses.bsd3;
    maintainers = with maintainers; [ costrouc ];
  };
}
