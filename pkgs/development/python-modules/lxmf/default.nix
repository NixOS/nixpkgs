{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  pythonOlder,
  rns,
  setuptools,
}:

buildPythonPackage rec {
  pname = "lxmf";
  version = "0.7.1";
  pyproject = true;

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "markqvist";
    repo = "lxmf";
    tag = version;
    hash = "sha256-BSQhhjiZcu9xctEXKQ2Dr4GQNkX7DUIpsncG8zUO74Y=";
  };

  build-system = [ setuptools ];

  dependencies = [ rns ];

  # Module has no tests
  doCheck = false;

  pythonImportsCheck = [ "LXMF" ];

  meta = with lib; {
    description = "Lightweight Extensible Message Format for Reticulum";
    homepage = "https://github.com/markqvist/lxmf";
    changelog = "https://github.com/markqvist/LXMF/releases/tag/${version}";
    # Reticulum License
    # https://github.com/markqvist/LXMF/blob/master/LICENSE
    license = licenses.unfree;
    maintainers = with maintainers; [ fab ];
    mainProgram = "lxmd";
  };
}
