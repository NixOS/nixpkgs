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
  version = "0.7.0";
  pyproject = true;

  disabled = pythonOlder "3.8";

  src = fetchFromGitHub {
    owner = "stumpylog";
    repo = "gotenberg-client";
    rev = "refs/tags/${version}";
    hash = "sha256-pkxu9WIsyHW2iTepv5B2naKkK+yw8lT+i3EwobE+u1M=";
  };

  nativeBuildInputs = [ hatchling ];

  propagatedBuildInputs =
    [
      httpx
    ]
    ++ lib.optionals (pythonOlder "3.11") [ typing-extensions ]
    ++ httpx.optional-dependencies.http2;

  pythonImportsCheck = [ "gotenberg_client" ];

  meta = with lib; {
    description = "Python client for interfacing with the Gotenberg API";
    homepage = "https://github.com/stumpylog/gotenberg-client";
    changelog = "https://github.com/stumpylog/gotenberg-client/blob/${version}/CHANGELOG.md";
    license = licenses.mpl20;
    maintainers = with maintainers; [ leona ];
  };
}
