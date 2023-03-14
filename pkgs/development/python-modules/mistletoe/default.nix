{ lib
, fetchPypi
, buildPythonPackage
, pythonOlder
}:

buildPythonPackage rec {
  pname = "mistletoe";
  version = "1.0.0";
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-+g6cV+IFDP1orjBOT5xeHmk1dMxf2DI9szRSlJ1oJmE=";
  };

  pythonImportsCheck = [
    "mistletoe"
  ];

  meta = with lib; {
    description = "Fast and extensible Markdown parser";
    homepage = "https://github.com/miyuchina/mistletoe";
    changelog = "https://github.com/miyuchina/mistletoe/releases/tag/v${version}";
    license = licenses.mit;
    maintainers = with maintainers; [ eadwu ];
  };
}
