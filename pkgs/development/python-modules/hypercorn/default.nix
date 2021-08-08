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
, pytest-asyncio
, pytest-cov
, pytest-sugar
, pytest-trio
, pytestCheckHook
}:

buildPythonPackage rec {
  pname = "Hypercorn";
  version = "0.11.2";
  disabled = pythonOlder "3.7";

  src = fetchFromGitLab {
    owner = "pgjones";
    repo = pname;
    rev = version;
    sha256 = "0v80v6l2xqac5mgrmh2im7y23wpvz4yc2v4h9ryhvl88c2jk9mvh";
  };

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
