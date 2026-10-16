{
  lib,
  buildPythonPackage,
  fetchPypi,
  blessed,
  docopt,
  pillow,
  requests,
}:

buildPythonPackage rec {
  pname = "pixcat";
  version = "0.1.4";
  format = "setuptools";

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

  meta = {
    description = "Display images on a kitty terminal with optional resizing";
    mainProgram = "pixcat";
    homepage = "https://github.com/mirukan/pixcat";
    license = lib.licenses.lgpl3;
    maintainers = [ lib.maintainers.tilcreator ];
  };
}
