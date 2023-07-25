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
  version = "0.29.0";

  src = fetchFromGitHub {
    owner = "Farama-Foundation";
    repo = pname;
    rev = "refs/tags/v${version}";
    hash = "sha256-4YaEFEWSOTEdGgO1kSOleZQp7OrcOf+WAT/E0BWeoKI=";
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
