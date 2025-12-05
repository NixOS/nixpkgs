{
  lib,
  buildPythonPackage,
  fetchPypi,
  drawille,
  matplotlib,
}:

buildPythonPackage rec {
  pname = "drawilleplot";
  version = "0.1.0";

  format = "setuptools";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-ZEDroo7KkI2VxdESb2QDX+dPY4UahuuK9L0EddrxJjQ=";
  };

  doCheck = false; # does not have any tests at all

  propagatedBuildInputs = [
    drawille
    matplotlib
  ];

  pythonImportsCheck = [ "drawilleplot" ];

  meta = with lib; {
    description = "Matplotlib backend for graph output in unicode terminals using drawille";
    homepage = "https://github.com/gooofy/drawilleplot";
    license = licenses.asl20;
    maintainers = with maintainers; [ nobbz ];
    platforms = platforms.all;
  };
}
