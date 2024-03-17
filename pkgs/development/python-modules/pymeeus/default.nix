{ lib, buildPythonPackage, fetchPypi, pytest }:

buildPythonPackage rec {
  pname = "pymeeus";
  version = "0.5.12";

  src = fetchPypi {
    pname = "PyMeeus";
    inherit version;
    hash = "sha256-VI9xhr2LlsvAac9kmo6ON33OSax0SGcJhJ/mOpnK1oQ=";
  };

  nativeCheckInputs = [ pytest ];

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
