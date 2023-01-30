{ lib
, buildPythonPackage
, fetchPypi
, pythonOlder
}:

buildPythonPackage rec {
  pname = "peaqevcore";
  version = "11.0.4";
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-SU8vsKwZio/5UD2SMhLenfkBjXRuMZCPo2k6+1hx8Y4=";
  };

  postPatch = ''
    substituteInPlace setup.py \
      --replace "pytest" ""
  '';

  # Tests are not shipped and source is not tagged
  # https://github.com/elden1337/peaqev-core/issues/4
  doCheck = false;

  pythonImportsCheck = [
    "peaqevcore"
  ];

  meta = with lib; {
    description = "Library for interacting with Peaqev car charging";
    homepage = "https://github.com/elden1337/peaqev-core";
    license = with licenses; [ mit ];
    maintainers = with maintainers; [ fab ];
  };
}
