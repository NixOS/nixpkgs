{ lib
, buildPythonPackage
, fetchFromGitHub
, pythonOlder
, anyio
, asyncio-rlock
, asyncio-throttle
, ircstates
, async_stagger
, async-timeout
, python
}:

buildPythonPackage rec {
  pname = "ircrobots";
  version = "0.4.6";
  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "jesopo";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-+BrS1+ZkgwT/qvqD0PwRZi2LF+31biS738SzKH1dy7w=";
  };

  postPatch = ''
    # too specific pins https://github.com/jesopo/ircrobots/issues/3
    sed -iE 's/anyio.*/anyio/' requirements.txt
    sed -iE 's/ircstates.*/ircstates/' requirements.txt
    sed -iE 's/async_timeout.*/async_timeout/' requirements.txt
  '';

  propagatedBuildInputs = [
    anyio
    asyncio-rlock
    asyncio-throttle
    ircstates
    async_stagger
    async-timeout
  ];

  checkPhase = ''
    ${python.interpreter} -m unittest test
  '';

  pythonImportsCheck = [ "ircrobots" ];

  meta = with lib; {
    description = "Asynchronous bare-bones IRC bot framework for python3";
    license = licenses.mit;
    homepage = "https://github.com/jesopo/ircrobots";
    maintainers = with maintainers; [ hexa ];
  };
}
