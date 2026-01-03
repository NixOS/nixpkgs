{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  python-dateutil,
  six,
  pytestCheckHook,
}:

buildPythonPackage {
  pname = "bson";
  version = "0.5.10-unstable-2025-11-27";
  format = "setuptools";

  src = fetchFromGitHub {
    owner = "py-bson";
    repo = "bson";
    rev = "4e6b4c206f7204034ef74bff8ae84a95d76d1684";
    hash = "sha256-SNtCd97DoCh/w6q7vbTskSHuPCxwMy3/2Dky7F5arQQ=";
  };

  postPatch = ''
    find . -type f -name '*.py' -exec sed -i 's|assertEquals|assertEqual|g' {} +
  '';

  propagatedBuildInputs = [
    python-dateutil
    six
  ];

  checkInputs = [ pytestCheckHook ];

  pythonImportsCheck = [ "bson" ];

  meta = {
    description = "BSON codec for Python";
    homepage = "https://github.com/py-bson/bson";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ fab ];
  };
}
