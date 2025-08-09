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
  version = "0.7.2";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "jesopo";
    repo = "ircrobots";
    rev = "v${version}";
    hash = "sha256-slz4AH2Mi21N3aV+OrnoXoQsseS7arW2NuUZARQJsf0=";
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
