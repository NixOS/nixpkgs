{ lib
, fetchFromGitHub
, buildPythonPackage
, jsonschema
, nox
}:

buildPythonPackage rec {
  pname = "restinstance";
  version = "1.3.0";
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "asyrjasalo";
    repo = pname;
    rev = "refs/tags/${version}";
    hash = "sha256-ed0gJy0ns+Xs7DO0P7c8Jea9qI5A+tImUEG5Xz8Q3Ng=";
  };

  nativeCheckInputs = [ jsonschema nox ];

  checkPhase = ''
    nox -s test
  '';

  pythonImportsCheck = [
    "REST"
  ];
  meta = with lib; {
    description = "Robot Framework library for RESTful JSON APIs";
    homepage = "https://asyrjasalo.github.io/RESTinstance";
    changelog = "https://github.com/asyrjasalo/RESTinstance/releases/tag/${version}";
    license = licenses.lgpl3Only;
    maintainers = with maintainers; [ asyrjasalo ];
  };
}
