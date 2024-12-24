{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  pythonOlder,
  setuptools,
  requests,
}:

buildPythonPackage rec {
  pname = "pyosf";
  version = "1.0.5";
  pyproject = true;

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "psychopy";
    repo = pname;
    rev = "refs/tags/v${version}";
    hash = "sha256-Yhb6HSnLdFzWouse/RKZ8SIbMia/hhD8TAovdqmvd7o=";
  };

  postPatch = ''
    substituteInPlace setup.py \
      --replace-fail "'pytest-runner', " ""
  '';

  preBuild = "export HOME=$TMP";

  build-system = [ setuptools ];

  dependencies = [ requests ];

  # Tests require network access
  doCheck = false;

  pythonImportsCheck = [ "pyosf" ];

  meta = with lib; {
    description = "Pure Python library for simple sync with Open Science Framework";
    homepage = "https://github.com/psychopy/pyosf";
    changelog = "https://github.com/psychopy/pyosf/releases/tag/v${version}";
    license = licenses.mit;
    maintainers = with maintainers; [ bcdarwin ];
  };
}
