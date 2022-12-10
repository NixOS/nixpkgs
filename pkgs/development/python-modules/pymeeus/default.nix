{ lib, buildPythonPackage, fetchPypi, pytest }:

buildPythonPackage rec {
  pname = "PyMeeus";
  version = "0.5.11";

  src = fetchPypi {
    inherit pname version;
    sha256 = "bb9d670818d8b0594317b48a7dadea02a0594e5344263bf2054e1a011c8fed55";
  };

  checkInputs = [ pytest ];

  checkPhase = ''
    pytest .
  '';

  meta = with lib; {
    homepage = "https://github.com/architest/pymeeus";
    description = "Library of astronomical algorithms";
    license = licenses.lgpl3;
    maintainers = with maintainers; [ jluttine ];
  };
}
