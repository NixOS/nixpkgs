{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  setuptools,
  requests,
  six,
}:

buildPythonPackage rec {
  pname = "pysignalclirestapi";
  version = "0.3.24";

  pyproject = true;

  src = fetchFromGitHub {
    owner = "bbernhard";
    repo = "pysignalclirestapi";
    rev = "refs/tags/${version}";
    hash = "sha256-LGP/Oo4FCvOq3LuUZRYFkK2JV1kEu3MeCDgnYo+91o4=";
  };

  nativeBuildInputs = [ setuptools ];

  propagatedBuildInputs = [
    requests
    six
  ];

  # upstream has no tests
  doCheck = false;

  pythonImportsCheck = [ "pysignalclirestapi" ];

  meta = with lib; {
    changelog = "https://github.com/bbernhard/pysignalclirestapi/releases/tag/${version}";
    description = "Small python library for the Signal Cli REST API";
    homepage = "https://github.com/bbernhard/pysignalclirestapi";
    license = licenses.mit;
    maintainers = with maintainers; [ dotlambda ];
  };
}
