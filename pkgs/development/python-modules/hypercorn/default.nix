{ lib
, buildPythonPackage
, fetchFromGitLab
, pythonOlder
, typing-extensions
, wsproto
, toml
, h2
, priority
, mock
, poetry-core
, pytest-asyncio
, pytest-cov
, pytest-sugar
, pytest-trio
, pytestCheckHook
}:

buildPythonPackage rec {
  pname = "Hypercorn";
  version = "0.13.2";
  disabled = pythonOlder "3.7";
  format = "pyproject";

  src = fetchFromGitLab {
    owner = "pgjones";
    repo = pname;
    rev = version;
    sha256 = "sha256-fIjw5A6SvFUv8cU7xunVlPYphv+glypY4pzvHNifYLQ=";
  };

  nativeBuildInputs = [
    poetry-core
  ];

  propagatedBuildInputs = [ wsproto toml h2 priority ]
    ++ lib.optionals (pythonOlder "3.8") [ typing-extensions ];

  checkInputs = [
    pytest-asyncio
    pytest-cov
    pytest-sugar
    pytest-trio
    pytestCheckHook
  ] ++ lib.optionals (pythonOlder "3.8") [ mock ];

  pythonImportsCheck = [ "hypercorn" ];

  meta = with lib; {
    homepage = "https://pgjones.gitlab.io/hypercorn/";
    description = "The ASGI web server inspired by Gunicorn";
    license = licenses.mit;
    maintainers = with maintainers; [ dgliwka ];
  };
}
