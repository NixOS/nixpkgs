{ lib
, buildPythonPackage
, fetchFromGitLab
, isPy27, isPy35, isPy36
, pythonOlder
, typing-extensions
, wsproto
, toml
, h2
, priority
, tox
}:

buildPythonPackage rec {
  pname = "Hypercorn";
  version = "0.11.2";
  disabled = isPy27 || isPy35 || isPy36;

  src = fetchFromGitLab {
    owner = "pgjones";
    repo = pname;
    rev = version;
    sha256 = "0v80v6l2xqac5mgrmh2im7y23wpvz4yc2v4h9ryhvl88c2jk9mvh";
  };

  propagatedBuildInputs = [ wsproto toml h2 priority ]
  ++ lib.optionals (pythonOlder "3.8") [ typing-extensions ];

  checkInputs = [ tox ];

  checkPhase = "tox -e py37,py38,py39 -s";

  pythonImportsCheck = [ "hypercorn" ];

  meta = with lib; {
    homepage = "https://pgjones.gitlab.io/hypercorn/";
    description = "The ASGI web server inspired by Gunicorn";
    license = licenses.mit;
    maintainers = with maintainers; [ dgliwka ];
  };
}
