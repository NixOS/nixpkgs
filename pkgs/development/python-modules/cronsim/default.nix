{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  setuptools,
  pytestCheckHook,
}:

buildPythonPackage rec {
  pname = "cronsim";
  version = "2.7";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "cuu508";
    repo = "cronsim";
    tag = version;
    hash = "sha256-9TextQcZAX5Ri6cc+Qd4T+u8XjxriqoTsy/9/G8XDAM=";
  };

  build-system = [ setuptools ];

  nativeCheckInputs = [ pytestCheckHook ];

  pythonImportsCheck = [ "cronsim" ];

<<<<<<< HEAD
  meta = {
    description = "Cron expression parser and evaluator";
    homepage = "https://github.com/cuu508/cronsim";
    license = lib.licenses.bsd3;
    maintainers = with lib.maintainers; [ phaer ];
=======
  meta = with lib; {
    description = "Cron expression parser and evaluator";
    homepage = "https://github.com/cuu508/cronsim";
    license = licenses.bsd3;
    maintainers = with maintainers; [ phaer ];
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  };
}
