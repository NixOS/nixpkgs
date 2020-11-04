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
  version = "0.3.3";
  disabled = pythonOlder "3.6";

  src = fetchFromGitHub {
    owner = "jesopo";
    repo = pname;
    rev = "v${version}";
    sha256 = "0ykn6ch7aazv2cx13q2gr94arh6f96d8hwjwnrcjai3i3x4q2pkq";
  };

  patches = [
    ./relax-dependencies.patch
  ];

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
