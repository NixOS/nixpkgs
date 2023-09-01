{ lib
, fetchFromGitHub
, buildPythonPackage
, jsonschema
, nox
}:

buildPythonPackage rec {
  pname = "RESTinstance";
  version = "1.3.0";

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

  meta = with lib; {
    description = "Robot Framework library for RESTful JSON APIs";
    homepage = "https://asyrjasalo.github.io/RESTinstance";
    license = licenses.lgpl3Only;
    maintainers = with maintainers; [ asyrjasalo ];
  };
}
