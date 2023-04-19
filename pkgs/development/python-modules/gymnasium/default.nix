{ lib
, buildPythonPackage
, fetchFromGitHub
, setuptools
, numpy
, cloudpickle
, gym-notices
, jax-jumpy
, typing-extensions
, farama-notifications
, importlib-metadata
, pythonOlder
}:

buildPythonPackage rec {
  pname = "gymnasium";
  version = "0.28.1";

  src = fetchFromGitHub {
    owner = "Farama-Foundation";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-7rRF21H3IxbgmqxvtC370kr0exLgfg3e2tA3J49xuao=";
  };

  format = "pyproject";

  nativeBuildInputs = [ setuptools ];

  propagatedBuildInputs = [
    jax-jumpy
    cloudpickle
    numpy
    gym-notices
    typing-extensions
    farama-notifications
  ] ++ lib.optionals (pythonOlder "3.10") [ importlib-metadata ];

  pythonImportsCheck = [ "gymnasium" ];

  meta = with lib; {
    description = "A standard API for reinforcement learning and a diverse set of reference environments (formerly Gym)";
    homepage = "https://github.com/Farama-Foundation/Gymnasium";
    license = licenses.mit;
    maintainers = with maintainers; [ GaetanLepage ];
  };
}
