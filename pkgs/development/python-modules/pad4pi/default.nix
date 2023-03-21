{ lib, buildPythonPackage, fetchPypi, rpi-gpio }:

buildPythonPackage rec {
  pname = "pad4pi";
  version = "1.1.5";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-+oVYlqF5PQAFz4EO1ap6pjmYTLg9xQy6UbQja4utt2Q=";
  };

  propagatedBuildInputs = [ rpi-gpio ];

  # Checks depend on rpi-gpio which requires to be run on a Raspberry Pi,
  # therefore it fails on other systems
  doCheck = false;

  meta = with lib; {
    homepage = "https://github.com/brettmclean/pad4pi";
    description = "Interrupt-based matrix keypad library for Raspberry Pi";
    license = licenses.lgpl3;
    maintainers = with maintainers; [ onny ];
  };
}
