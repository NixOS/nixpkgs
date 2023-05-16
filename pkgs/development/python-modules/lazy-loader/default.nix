{ lib
, buildPythonPackage
, fetchFromGitHub
, flit-core
, pytestCheckHook
}:

buildPythonPackage rec {
  pname = "lazy-loader";
<<<<<<< HEAD
  version = "0.3";
=======
  version = "0.2";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  format = "pyproject";

  src = fetchFromGitHub {
    owner = "scientific-python";
    repo = "lazy_loader";
    rev = "refs/tags/v${version}";
<<<<<<< HEAD
    hash = "sha256-Ky9EwPYt/wBqWXopH5WFjlVG+/Rd2gc+mlCeWqG7mZg=";
=======
    hash = "sha256-QiRJt2aR2mY1f9ci/p6jOyMeyrHPqRdh43l4Th5PYf8=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  };

  nativeBuildInputs = [
    flit-core
  ];

  nativeCheckInputs = [
    pytestCheckHook
  ];

  meta = with lib; {
    description = "Populate library namespace without incurring immediate import costs";
    homepage = "https://github.com/scientific-python/lazy_loader";
    changelog = "https://github.com/scientific-python/lazy_loader/releases/tag/v${version}";
    license = licenses.bsd3;
    maintainers = with maintainers; [ hexa ];
  };
}
