{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  setuptools,
  pythonOlder,
}:

buildPythonPackage rec {
  pname = "psychrolib";
  version = "2.5.0";
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "psychrometrics";
    repo = "psychrolib";
    rev = "refs/tags/${version}";
    hash = "sha256-OkjoYIakF7NXluNTaJnUHk5cI5t8GnpqrbqHYwnLOts=";
  };

  sourceRoot = "${src.name}/src/python";

  nativeBuildInputs = [ setuptools ];

  # Module has no tests
  doCheck = false;

  pythonImportsCheck = [ "psychrolib" ];

  meta = with lib; {
    description = "Library of psychrometric functions to calculate thermodynamic properties";
    homepage = "https://github.com/psychrometrics/psychrolib";
    changelog = "https://github.com/psychrometrics/psychrolib/releases/tag/${version}";
    license = licenses.mit;
    maintainers = with maintainers; [ fab ];
  };
}
