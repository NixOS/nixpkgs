{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  setuptools,
}:

buildPythonPackage rec {
  pname = "pbar";
  version = "2.2.1";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "darvil82";
    repo = "PBar";
    tag = "v${version}";
    hash = "sha256-FsEjfusk8isOD52xkjndGQdVC8Vc7N3spLLWQTi3Svc=";
  };

  build-system = [ setuptools ];
  pythonImportsCheck = [ "pbar" ];

<<<<<<< HEAD
  meta = {
    description = "Display customizable progress bars on the terminal easily";
    license = lib.licenses.mit;
    homepage = "https://darvil82.github.io/PBar";
    maintainers = with lib.maintainers; [ sigmanificient ];
=======
  meta = with lib; {
    description = "Display customizable progress bars on the terminal easily";
    license = licenses.mit;
    homepage = "https://darvil82.github.io/PBar";
    maintainers = with maintainers; [ sigmanificient ];
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  };
}
