{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  poetry-core,
  requests,
}:

buildPythonPackage rec {
  pname = "pylacus";
  version = "1.20.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "ail-project";
    repo = "PyLacus";
    tag = "v${version}";
    hash = "sha256-Ody+2zBnApdZqfmS6veWxHgrjVBO3xSulbu5/Uxd2u8=";
  };

  build-system = [ poetry-core ];

  dependencies = [ requests ];

  # Tests require network access
  doCheck = false;

  pythonImportsCheck = [ "pylacus" ];

  meta = with lib; {
    description = "Module to enqueue and query a remote Lacus instance";
    homepage = "https://github.com/ail-project/PyLacus";
    changelog = "https://github.com/ail-project/PyLacus/releases/tag/${src.tag}";
    license = licenses.bsd3;
    maintainers = with maintainers; [ fab ];
  };
}
