{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  requests,
}:

buildPythonPackage rec {
  pname = "pynetgear";
  version = "0.10.10";
  format = "setuptools";

  src = fetchFromGitHub {
    owner = "MatMaul";
    repo = "pynetgear";
    tag = version;
    hash = "sha256-5Lj2cK/SOGgaPu8dI9X3Leg4dPAY7tdIHCzFnNaube8=";
  };

  propagatedBuildInputs = [ requests ];

  pythonImportsCheck = [ "pynetgear" ];

  # Tests don't pass
  # https://github.com/MatMaul/pynetgear/issues/109
  doCheck = false;

  meta = {
    description = "Module for interacting with Netgear wireless routers";
    homepage = "https://github.com/MatMaul/pynetgear";
    changelog = "https://github.com/MatMaul/pynetgear/releases/tag/${version}";
    license = with lib.licenses; [ mit ];
    maintainers = with lib.maintainers; [ fab ];
  };
}
