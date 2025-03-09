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
    rev = "refs/tags/${version}";
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

  meta = with lib; {
    description = "BSON codec for Python";
    homepage = "https://github.com/py-bson/bson";
    license = licenses.asl20;
    maintainers = with maintainers; [ fab ];
  };
}
