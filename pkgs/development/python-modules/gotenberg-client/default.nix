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
  version = "0.5.0";
  pyproject = true;

  disabled = pythonOlder "3.8";

  src = fetchFromGitHub {
    owner = "stumpylog";
    repo = "gotenberg-client";
    rev = "refs/tags/${version}";
    hash = "sha256-38s7XLCh55uXxu/Go04Ku/m4xeqAAa2sRe4SiqIXolU=";
  };

  nativeBuildInputs = [ hatchling ];

  propagatedBuildInputs = [
    httpx
  ] ++ lib.optionals (pythonOlder "3.11") [ typing-extensions ] ++ httpx.optional-dependencies.http2;

  pythonImportsCheck = [ "gotenberg_client" ];

  meta = with lib; {
    description = "Python client for interfacing with the Gotenberg API";
    homepage = "https://github.com/stumpylog/gotenberg-client";
    changelog = "https://github.com/stumpylog/gotenberg-client/blob/${version}/CHANGELOG.md";
    license = licenses.mpl20;
    maintainers = with maintainers; [ leona ];
  };
}
