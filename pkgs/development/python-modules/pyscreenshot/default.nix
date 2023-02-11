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
  version = "3.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "dd4fdfaeb617483913a6b16845b9f428de5db28758979f4b6cf8f236d292b908";
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
