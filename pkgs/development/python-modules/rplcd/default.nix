{ lib, buildPythonPackage, fetchPypi }:

buildPythonPackage rec {
  pname = "rplcd";
  version = "1.3.0";

  src = fetchPypi {
    inherit version;
    pname = "RPLCD";
    sha256 = "sha256-AIEiL+IPU76DF+P08c5qokiJcZdNNDJ/Jjng2Z292LY=";
  };

  # Disable check because it depends on a GPIO library
  doCheck = false;

  meta = with lib; {
    homepage = "https://github.com/dbrgn/RPLCD";
    description = ''
      Raspberry Pi LCD library for the widely used Hitachi HD44780 controller
    '';
    license = licenses.mit;
    maintainers = with maintainers; [ onny ];
  };
}
