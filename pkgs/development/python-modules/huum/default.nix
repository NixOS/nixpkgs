{ lib
, aiohttp
, buildPythonPackage
, fetchPypi
, poetry-core
, pydantic
, pythonOlder
}:

buildPythonPackage rec {
  pname = "huum";
  version = "0.6.0";
  format = "pyproject";

  disabled = pythonOlder "3.9";

  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-PYOjfLPa/vZZP0IZuUZnQ74IrTRvizgYhKOmhd83aMQ=";
  };

  nativeBuildInputs = [
    poetry-core
  ];

  propagatedBuildInputs = [
    aiohttp
    pydantic
  ];

  # Tests are not shipped and source not tagged
  # https://github.com/frwickst/pyhuum/issues/2
  doCheck = false;

  pythonImportsCheck = [
    "huum"
  ];

  meta = with lib; {
    description = "Library for for Huum saunas";
    homepage = "https://github.com/frwickst/pyhuum";
    license = with licenses; [ mit ];
    maintainers = with maintainers; [ fab ];
  };
}
