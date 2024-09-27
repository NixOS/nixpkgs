{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  setuptools,
  anyio,
  asyncio-rlock,
  asyncio-throttle,
  ircstates,
  async-stagger,
  async-timeout,
  unittestCheckHook,
}:

buildPythonPackage rec {
  pname = "ircrobots";
  version = "0.6.6";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "jesopo";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-mIh3tERwHtGH9eA0AT8Lcnwp1Wn9lQhKkUjuZcOXO/c=";
  };

  build-system = [ setuptools ];

  pythonRelaxDeps = true;

  propagatedBuildInputs = [
    anyio
    asyncio-rlock
    asyncio-throttle
    ircstates
    async-stagger
    async-timeout
  ];

  nativeCheckInputs = [ unittestCheckHook ];

  pythonImportsCheck = [ "ircrobots" ];

  meta = with lib; {
    description = "Asynchronous bare-bones IRC bot framework for python3";
    license = licenses.mit;
    homepage = "https://github.com/jesopo/ircrobots";
    maintainers = with maintainers; [ hexa ];
  };
}
