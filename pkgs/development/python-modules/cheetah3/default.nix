{ lib
, buildPythonPackage
, fetchFromGitHub
, pythonOlder
}:

buildPythonPackage rec {
  pname = "cheetah3";
  version = "3.3.1";
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "CheetahTemplate3";
    repo = pname;
    rev = "refs/tags/${version}";
    hash = "sha256-op8CwYISD2Gfsh0Olr8H07yvaT1maKyizb/IN9ZHwmQ=";
  };

  doCheck = false; # Circular dependency

  pythonImportsCheck = [
    "Cheetah"
  ];

  meta = with lib; {
    description = "A template engine and code generation tool";
    homepage = "http://www.cheetahtemplate.org/";
    changelog = "https://github.com/CheetahTemplate3/cheetah3/releases/tag/${version}";
    license = licenses.mit;
    maintainers = with maintainers; [ pjjw ];
  };
}
