{ lib
, buildPythonPackage
, fetchPypi
, pythonOlder
}:

buildPythonPackage rec {
  pname = "peaqevcore";
  version = "15.1.1";
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-7cr37kvNgPPTYJd5r1RXy7qFNN0nXI74YHPg9k8ZDfw=";
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
