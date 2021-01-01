{ lib
, buildPythonPackage
, fetchPypi
, saneBackends
}:

buildPythonPackage rec {
  pname = "sane";
  version = "2.8.2";

  src = fetchPypi {
    inherit version;
    pname = "python-sane";
    sha256 = "0sri01h9sld6w7vgfhwp29n5w19g6idz01ba2giwnkd99k1y2iqg";
  };

  buildInputs = [
    saneBackends
  ];

  meta = with lib; {
    homepage = "https://github.com/python-pillow/Sane";
    description = "Python interface to the SANE scanner and frame grabber ";
    license = licenses.mit;
    maintainers = with maintainers; [ doronbehar ];
  };
}
