{
  lib,
  buildPythonPackage,
  fetchPypi,
  blessed,
  docopt,
  pillow,
  requests,
  pythonOlder,
}:

buildPythonPackage rec {
  pname = "pixcat";
  version = "0.1.4";
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-ZXyP4EUTyuzM1ghrNHqkuF22tMD3YbFiy5zXiavnq7Y=";
  };

  propagatedBuildInputs = [
    blessed
    docopt
    pillow
    requests
  ];

  pythonImportsCheck = [ "pixcat" ];

  meta = with lib; {
    description = "Display images on a kitty terminal with optional resizing";
    mainProgram = "pixcat";
    homepage = "https://github.com/mirukan/pixcat";
    license = licenses.lgpl3;
    maintainers = [ maintainers.tilcreator ];
  };
}
