{
  lib,
  buildPythonPackage,
  colorlog,
  pyyaml,
  fetchPypi,
  pythonOlder,
  requests,
  setuptools,
}:

buildPythonPackage rec {
  pname = "lupupy";
  version = "0.3.2";
  pyproject = true;

  disabled = pythonOlder "3.6";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-A92Jk6WlRKep3dkbqLiYYHklEh0pyncipRW6swq0mvo=";
  };

  nativeBuildInputs = [ setuptools ];

  propagatedBuildInputs = [
    colorlog
    pyyaml
    requests
  ];

  # Project has no tests
  doCheck = false;

  pythonImportsCheck = [ "lupupy" ];

  meta = with lib; {
    description = "Python module to control Lupusec alarm control panels";
    mainProgram = "lupupy";
    homepage = "https://github.com/majuss/lupupy";
    changelog = "https://github.com/majuss/lupupy/releases/tag/v${version}";
    license = with licenses; [ mit ];
    maintainers = with maintainers; [ fab ];
  };
}
