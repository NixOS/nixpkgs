{ lib
, buildPythonPackage
, fetchPypi
, pythonOlder
, setuptools
}:

buildPythonPackage rec {
  pname = "peaqevcore";
  version = "19.7.1";
  pyproject = true;

  disabled = pythonOlder "3.7";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-BVUnSKmLOF6DKirAI2lv8/tpcSGus2XZTPn3WSJjwgg=";
  };

  postPatch = ''
    sed -i "/extras_require/d" setup.py
  '';

  nativeBuildInputs = [
    setuptools
  ];

  # Tests are not shipped and source is not tagged
  # https://github.com/elden1337/peaqev-core/issues/4
  doCheck = false;

  pythonImportsCheck = [
    "peaqevcore"
  ];

  meta = with lib; {
    description = "Library for interacting with Peaqev car charging";
    homepage = "https://github.com/elden1337/peaqev-core";
    changelog = "https://github.com/elden1337/peaqev-core/releases/tag/${version}";
    license = with licenses; [ mit ];
    maintainers = with maintainers; [ fab ];
  };
}
