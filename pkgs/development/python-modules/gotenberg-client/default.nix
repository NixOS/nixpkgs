{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  pythonOlder,
  hatchling,
  httpx,
  typing-extensions,
}:
buildPythonPackage rec {
  pname = "gotenberg-client";
<<<<<<< HEAD
  version = "0.13.1";
=======
  version = "0.12.0";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  pyproject = true;

  src = fetchFromGitHub {
    owner = "stumpylog";
    repo = "gotenberg-client";
    tag = version;
<<<<<<< HEAD
    hash = "sha256-JYb0+Dj4QowcN+I6MMoWlv+Q5YoK4nfzYB/UNwhnRu8=";
=======
    hash = "sha256-+beO1Pp+ikfk4gqpfvIEHCOPZGLanGX6Kw4mqJglJTI=";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  };

  build-system = [ hatchling ];

  dependencies = [
    httpx
  ]
  ++ lib.optionals (pythonOlder "3.11") [ typing-extensions ]
  ++ httpx.optional-dependencies.http2;

  # requires running gotenberg service
  doCheck = false;

  pythonImportsCheck = [ "gotenberg_client" ];

<<<<<<< HEAD
  meta = {
    description = "Python client for interfacing with the Gotenberg API";
    homepage = "https://github.com/stumpylog/gotenberg-client";
    changelog = "https://github.com/stumpylog/gotenberg-client/blob/${src.tag}/CHANGELOG.md";
    license = lib.licenses.mpl20;
    maintainers = with lib.maintainers; [ leona ];
=======
  meta = with lib; {
    description = "Python client for interfacing with the Gotenberg API";
    homepage = "https://github.com/stumpylog/gotenberg-client";
    changelog = "https://github.com/stumpylog/gotenberg-client/blob/${src.tag}/CHANGELOG.md";
    license = licenses.mpl20;
    maintainers = with maintainers; [ leona ];
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  };
}
