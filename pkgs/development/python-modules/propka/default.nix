{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  pythonOlder,
  setuptools,
  pytestCheckHook,
}:

buildPythonPackage rec {
  pname = "propka";
  version = "3.5.1";
  pyproject = true;

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "jensengroup";
    repo = "propka";
    tag = "v${version}";
    hash = "sha256-EJQqCe4WPOpqsSxxfbTjF0qETpSPYqpixpylweTCjko=";
  };

  nativeBuildInputs = [ setuptools ];

  nativeCheckInputs = [ pytestCheckHook ];

  pythonImportsCheck = [ "propka" ];

<<<<<<< HEAD
  meta = {
=======
  meta = with lib; {
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
    description = "Predictor of the pKa values of ionizable groups in proteins and protein-ligand complexes based in the 3D structure";
    mainProgram = "propka3";
    homepage = "https://github.com/jensengroup/propka";
    changelog = "https://github.com/jensengroup/propka/releases/tag/v${version}";
<<<<<<< HEAD
    license = lib.licenses.lgpl21Only;
    maintainers = with lib.maintainers; [ natsukium ];
=======
    license = licenses.lgpl21Only;
    maintainers = with maintainers; [ natsukium ];
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  };
}
