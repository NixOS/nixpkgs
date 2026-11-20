{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  setuptools,
}:

buildPythonPackage rec {
  pname = "ping3";
  version = "5.1.6";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "kyan001";
    repo = "ping3";
    tag = "v${version}";
    hash = "sha256-9HWqJK8cxVKetrhcivI0p63I99XqkBVgZa6aR4Hablc=";
  };

  build-system = [ setuptools ];

  # Tests require additional permissions
  doCheck = false;

  pythonImportsCheck = [ "ping3" ];

  meta = {
    description = "ICMP ping implementation using raw socket";
    homepage = "https://github.com/kyan001/ping3";
    changelog = "https://github.com/kyan001/ping3/blob/master/CHANGELOG.md";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ siraben ];
    mainProgram = "ping3";
  };
}
