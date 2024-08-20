{
  lib,
  buildPythonPackage,
  fetchPypi,
}:

buildPythonPackage rec {
  pname = "fontawesomefree";
  version = "6.6.0";
  format = "wheel";

  # they only provide a wheel
  src = fetchPypi {
    inherit pname version format;
    dist = "py3";
    python = "py3";
    hash = "sha256-WZtXRDHJvZLtX8BU0QRaB8QjNdo2wXiE8rk0dV7vkIk=";
  };

  pythonImportsCheck = [ "fontawesomefree" ];

  meta = with lib; {
    homepage = "https://github.com/FortAwesome/Font-Awesome";
    description = "Icon library and toolkit";
    license = with licenses; [
      ofl
      cc-by-40
    ];
    maintainers = with maintainers; [ netali ];
  };
}
