{ lib
, buildPythonPackage
, fetchFromGitHub
, setuptools  
}:

buildPythonPackage rec {
  pname = "better-exceptions";
  version = "0.2.1";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "Qix-";
    repo = "better-exceptions";
    rev = version;
    hash = "";
  };

  nativeBuildInputs = [
    setuptools
  ];

  pythonImportsCheck = [
    "better_exceptions"
  ];

  meta = {
    description = "Pretty and useful exceptions in Python, automatically";
    homepage = "https://github.com/Qix-/better-exceptions";
    changelog = "https://github.com/Qix-/better-exceptions/releases/tag/${version}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ wolfangaukang ];
  };
}
