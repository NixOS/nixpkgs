{ lib
, buildPythonPackage
, fetchPypi
}:

buildPythonPackage rec {
  pname = "chevron";
  version = "0.13.1";

  src = fetchPypi {
    inherit pname version;
    sha256 = "f95054a8b303268ebf3efd6bdfc8c1b428d3fc92327913b4e236d062ec61c989";
  };

  meta = with lib; {
    description = "Mustache templating language renderer";
    homepage = https://github.com/noahmorrison/chevron;
    license = licenses.mit;
    maintainers = with maintainers; [ jnsaff ];
  };
}