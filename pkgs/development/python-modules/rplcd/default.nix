{
  lib,
  buildPythonPackage,
  fetchPypi,
}:

buildPythonPackage (finalAttrs: {
  pname = "rplcd";
  version = "1.4.0";
  format = "setuptools";

  src = fetchPypi {
    inherit (finalAttrs) pname version;
    hash = "sha256-Jl1qVOTtixYV29azPG8g/2ccZWFIyrMRrhtvo3CACVo=";
  };

  # Disable check because it depends on a GPIO library
  doCheck = false;

  meta = {
    homepage = "https://github.com/dbrgn/RPLCD";
    description = ''
      Raspberry Pi LCD library for the widely used Hitachi HD44780 controller
    '';
    mainProgram = "rplcd-tests";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ onny ];
  };
})
