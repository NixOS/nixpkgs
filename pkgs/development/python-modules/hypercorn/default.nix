{ lib
, buildPythonPackage
, fetchFromGitHub
, pythonOlder
, typing-extensions
, wsproto
, toml
, h2
, priority
, mock
, poetry-core
, pytest-asyncio
, pytest-trio
, pytestCheckHook
}:

buildPythonPackage rec {
  pname = "Hypercorn";
  version = "0.14.3";
  disabled = pythonOlder "3.7";
  format = "pyproject";

  src = fetchFromGitHub {
    owner = "pgjones";
    repo = pname;
    rev = version;
    hash = "sha256-ECREs8UwqTWUweUrwnUwpVotCII2v4Bz7ZCk3DSAd8I=";
  };

  postPatch = ''
    sed -i "/^addopts/d" pyproject.toml
  '';

  nativeBuildInputs = [
    poetry-core
  ];

  propagatedBuildInputs = [ wsproto toml h2 priority ]
    ++ lib.optionals (pythonOlder "3.8") [ typing-extensions ];

  nativeCheckInputs = [
    pytest-asyncio
    pytest-trio
    pytestCheckHook
  ] ++ lib.optionals (pythonOlder "3.8") [ mock ];

  pythonImportsCheck = [ "hypercorn" ];

  meta = with lib; {
    homepage = "https://github.com/pgjones/hypercorn";
    description = "The ASGI web server inspired by Gunicorn";
    license = licenses.mit;
    maintainers = with maintainers; [ dgliwka ];
  };
}
