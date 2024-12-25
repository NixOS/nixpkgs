{
  lib,
  buildPythonPackage,
  fetchPypi,
}:

buildPythonPackage rec {
  pname = "rplcd";
  version = "1.3.1";
  format = "setuptools";

  src = fetchPypi {
    inherit version;
    pname = "RPLCD";
    hash = "sha256-uZ0pPzWK8cBSX8/qvcZGYEnlVdtWn/vKPyF1kfwU5Pk=";
  };

  # Disable check because it depends on a GPIO library
  doCheck = false;

  meta = with lib; {
    homepage = "https://github.com/dbrgn/RPLCD";
    description = ''
      Raspberry Pi LCD library for the widely used Hitachi HD44780 controller
    '';
    mainProgram = "rplcd-tests";
    license = licenses.mit;
    maintainers = with maintainers; [ onny ];
  };
}
