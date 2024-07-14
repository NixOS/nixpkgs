{
  lib,
  buildPythonPackage,
  fetchPypi,
}:

buildPythonPackage rec {
  pname = "ipaddr";
  version = "2.2.0";
  format = "setuptools";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-QJLf5mdYjRaqErWay3yKQCTl3LI6aBzQsLYCNz7KiNY=";
  };

  checkPhase = ''
    python ipaddr_test.py
  '';

  meta = with lib; {
    description = "IP address manipulation library";
    homepage = "https://github.com/google/ipaddr-py";
    license = licenses.asl20;
    maintainers = [ maintainers.astro ];
  };
}
