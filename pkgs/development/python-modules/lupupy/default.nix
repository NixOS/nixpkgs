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

<<<<<<< HEAD
  meta = {
=======
  meta = with lib; {
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
    description = "Python module to control Lupusec alarm control panels";
    mainProgram = "lupupy";
    homepage = "https://github.com/majuss/lupupy";
    changelog = "https://github.com/majuss/lupupy/releases/tag/v${version}";
<<<<<<< HEAD
    license = with lib.licenses; [ mit ];
    maintainers = with lib.maintainers; [ fab ];
=======
    license = with licenses; [ mit ];
    maintainers = with maintainers; [ fab ];
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  };
}
