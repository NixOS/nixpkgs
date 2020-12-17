{ lib
, buildPythonPackage
, fetchFromGitHub
, pythonOlder
, anyio
, asyncio-throttle
, dataclasses
, ircstates
, async_stagger
, async-timeout
, python
}:

buildPythonPackage rec {
  pname = "ircrobots";
  version = "0.3.6";
  disabled = pythonOlder "3.6";

  src = fetchFromGitHub {
    owner = "jesopo";
    repo = pname;
    rev = "v${version}";
    sha256 = "1c8h8b78gmnfipppr9dxp7sl6wd9lx4l3pdwykaib1f49dqwavys";
  };

  postPatch = ''
    # too specific pins https://github.com/jesopo/ircrobots/issues/3
    sed -iE 's/anyio.*/anyio/' requirements.txt
  '';

  propagatedBuildInputs = [
    anyio
    asyncio-throttle
    ircstates
    async_stagger
    async-timeout
  ] ++ lib.optionals (pythonOlder "3.7") [
    dataclasses
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
