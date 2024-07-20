{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  pythonOlder,
  anyio,
  asyncio-rlock,
  asyncio-throttle,
  ircstates,
  async-stagger,
  async-timeout,
  python,
}:

buildPythonPackage rec {
  pname = "ircrobots";
  version = "0.6.6";
  format = "setuptools";
  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "jesopo";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-mIh3tERwHtGH9eA0AT8Lcnwp1Wn9lQhKkUjuZcOXO/c=";
  };

  postPatch = ''
    # too specific pins https://github.com/jesopo/ircrobots/issues/3
    sed -iE 's/anyio.*/anyio/' requirements.txt
  '';

  propagatedBuildInputs = [
    anyio
    asyncio-rlock
    asyncio-throttle
    ircstates
    async-stagger
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
