{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  fetchurl,
  importlib-resources,
  pytestCheckHook,
  python,
  pythonOlder,
  setuptools,
}:
let
  table = fetchurl {
    # See https://github.com/dahlia/iso4217/blob/main/setup.py#L19
    url = "https://www.six-group.com/dam/download/financial-information/data-center/iso-currrency/lists/list-one.xml";
    hash = "sha256-r1mRvI/qcOYOGKVzXHJGFdYxc+YlzpcdnWJExaF0Mp0=";
  };
in
buildPythonPackage rec {
  pname = "iso4217";
  version = "1.14";
  pyproject = true;

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "dahlia";
    repo = "iso4217";
    tag = version;
    hash = "sha256-lGXNSUBv/So3UgqXQ5AksqrCJVoyU8icDCfOda7Y5BE=";
  };

  build-system = [ setuptools ];

  dependencies = lib.optionals (pythonOlder "3.9") [ importlib-resources ];

  nativeCheckInputs = [ pytestCheckHook ];

  preBuild = ''
    # The table is already downloaded
    export ISO4217_DOWNLOAD=0
    # Copy the table file to satifiy the build process
    cp -r ${table} iso4217/table.xml
  '';

  postInstall = ''
    # Copy the table file
    cp -r ${table} $out/${python.sitePackages}/iso4217/table.xml
  '';

  enabledTestPaths = [ "iso4217/test.py" ];

  pythonImportsCheck = [ "iso4217" ];

  meta = with lib; {
    description = "ISO 4217 currency data package for Python";
    homepage = "https://github.com/dahlia/iso4217";
    license = with licenses; [ publicDomain ];
    maintainers = with maintainers; [ fab ];
  };
}
