{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  setuptools,
  wheel,
  orjson,
  aiofiles,
}:

buildPythonPackage rec {
  pname = "pickledb";
  version = "1.3.2";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "patx";
    repo = "pickledb";
    rev = "v${version}";
    hash = "sha256-19jPKEJ02rRHUYlKs9M0CorDnOMPw2+BpeVQL4Ysj0U=";
  };

  build-system = [
    setuptools
    wheel
  ];

  propagatedBuildInputs = [
    orjson
    aiofiles
  ];

  pythonImportsCheck = [
    "pickledb"
  ];

  meta = {
    description = "PickleDB is an in memory key-value store using Python's orjson module for persistence";
    homepage = "https://github.com/patx/pickledb";
    license = lib.licenses.bsd3;
    maintainers = with lib.maintainers; [ ];
  };
}
