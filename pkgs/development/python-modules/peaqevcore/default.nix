{ lib
, buildPythonPackage
, fetchPypi
, pythonOlder
}:

buildPythonPackage rec {
  pname = "peaqevcore";
  version = "0.0.19";
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-eEMzhrVKZJjUYwwdZ8M+xi0pbxseOS4ddW9il4XYwJs=";
  };

  postPatch = ''
    substituteInPlace setup.py \
      --replace "datetime" "" \
      --replace "statistics" "" \
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
