{
  fetchFromGitHub,
  lib,
  buildPythonPackage,
  # Dependencies
  python-dotenv,
}:
buildPythonPackage rec {
  pname = "rootutils";
  version = "1.0.7";
  src = fetchFromGitHub {
    owner = "ashleve";
    repo = "rootutils";
    tag = "v${version}";
    hash = "sha256-MY6kYB3IhMvyLCVVC2kdpMvbwKY4XyTfq9cXxbqbnPI=";
  };

  propagatedBuildInputs = [
    python-dotenv
  ];

  pythonImportsCheck = [ "rootutils" ];

  meta = {
    maintainers = with lib.maintainers; [ xddxdd ];
    description = "Simple python package to solve all your problems with pythonpath, work dir, file paths, module imports and environment variables";
    homepage = "https://pypi.org/project/rootutils/";
    license = with lib.licenses; [ mit ];
  };
}
