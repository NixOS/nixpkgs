{ lib
, buildPythonPackage
, fetchPypi
, isPy3k
, EasyProcess
, entrypoint2
, jeepney
, mss
}:

buildPythonPackage rec {
  pname = "pyscreenshot";
  version = "2.2";

  src = fetchPypi {
    inherit pname version;
    sha256 = "dec8517cb18faf4f983dd2ee6636924e472a5644da1480ae871786dfcac244e9";
  };

  propagatedBuildInputs = [
    EasyProcess
    entrypoint2
  ] ++ lib.optionals (isPy3k) [
    jeepney
    mss
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
