{
  lib,
  buildPythonPackage,
  fetchPypi,
  isPy3k,
  easyprocess,
  entrypoint2,
  jeepney,
  mss,
  pillow,
}:

buildPythonPackage rec {
  pname = "pyscreenshot";
  version = "3.1";
  format = "setuptools";

  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-jA6T8K72amv+Vahqv87WvTlq5LT2zB428EoorSYlWU0=";
  };

  propagatedBuildInputs =
    [
      easyprocess
      entrypoint2
      pillow
    ]
    ++ lib.optionals (isPy3k) [
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
    maintainers = with maintainers; [ ];
  };
}
