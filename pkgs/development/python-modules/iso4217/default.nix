{ lib
, buildPythonPackage
, fetchFromGitHub
, fetchurl
, importlib-resources
, pytestCheckHook
, python
, pythonOlder
}:
let
  table = fetchurl {
    # See https://github.com/dahlia/iso4217/blob/main/setup.py#L19
    url = "http://www.currency-iso.org/dam/downloads/lists/list_one.xml";
    hash = "sha256-bp8uTMR1YRaI2cJLo0kdt9xD4nNaWK+LdlheWQ26qy0=";
  };
in
buildPythonPackage rec {
  pname = "iso4217";
  version = "1.8";
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "dahlia";
    repo = pname;
    rev = version;
    hash = "sha256-L0vx6Aan6D1lusgBh/pcT373ZTxbtWpQnFKB2V0dxlA=";
  };

  propagatedBuildInputs = lib.optionals (pythonOlder "3.9") [
    importlib-resources
  ];

  checkInputs = [
    pytestCheckHook
  ];

  preBuild = ''
    # The table is already downloaded
    export ISO4217_DOWNLOAD=0
    # Copy the table file to satifiy the build process
    cp -r ${table} $pname/table.xml
  '';

  postInstall = ''
    # Copy the table file
    cp -r ${table} $out/${python.sitePackages}/$pname/table.xml
  '';

  pytestFlagsArray = [
    "$pname/test.py"
  ];

  pythonImportsCheck = [
    "iso4217"
  ];

  meta = with lib; {
    description = "ISO 4217 currency data package for Python";
    homepage = "https://github.com/dahlia/iso4217";
    license = with licenses; [ publicDomain ];
    maintainers = with maintainers; [ fab ];
  };
}
