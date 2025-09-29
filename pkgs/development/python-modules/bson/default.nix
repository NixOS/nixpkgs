{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  python-dateutil,
  six,
  pytestCheckHook,
}:

buildPythonPackage rec {
  pname = "bson";
  version = "0.5.10";
  format = "setuptools";

  src = fetchFromGitHub {
    owner = "py-bson";
    repo = "bson";
    tag = version;
    hash = "sha256-mirRpo27RoOBlwxVOKnHaDIzJOErp7c2VxCOunUm/u4=";
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
