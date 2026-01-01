{
  buildPythonPackage,
  fetchFromGitea,
  lib,
  poetry-core,
  pycountry,
  pyrate-limiter,
  requests,
  typing-extensions,
}:

buildPythonPackage rec {
  pname = "psnawp";
<<<<<<< HEAD
  version = "3.0.1";
=======
  version = "3.0.0";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  pyproject = true;

  src = fetchFromGitea {
    domain = "codeberg.org";
    owner = "YoshikageKira";
    repo = "psnawp";
    tag = "v${version}";
<<<<<<< HEAD
    hash = "sha256-qENKZC5U4jedl2RvmIGk52r0Vd/oMLEcp6DERYLctAs=";
=======
    hash = "sha256-JS8VGwIsCr21rwjXCRUXsoVHfFyLTZtgp+ZJcXWCCsQ=";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  };

  build-system = [ poetry-core ];

  dependencies = [
    pycountry
    pyrate-limiter
    requests
    typing-extensions
  ];

  pythonImportsCheck = [ "psnawp_api" ];

  # tests access the actual PlayStation Network API
  doCheck = false;

  meta = {
    changelog = "https://codeberg.org/YoshikageKira/psnawp/releases/tag/${src.tag}";
    description = "Python API Wrapper for PlayStation Network API";
    homepage = "https://codeberg.org/YoshikageKira/psnawp";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ dotlambda ];
  };
}
