{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  fetchpatch,
  pythonOlder,
  setuptools,
}:

buildPythonPackage rec {
  pname = "asynccmd";
  version = "0.2.4";
  pyproject = true;

  disabled = pythonOlder "3.6";

  src = fetchFromGitHub {
    owner = "valentinmk";
    repo = "asynccmd";
    rev = "refs/tags/${version}";
    hash = "sha256-0AjOKAEiwHi3AkzMGRvE/czTCfShXQAm8mDz98EESgs=";
  };

  patches = [
    # Deprecation of asyncio.Task.all_tasks(), https://github.com/valentinmk/asynccmd/pull/2
    (fetchpatch {
      name = "deprecation-python-38.patch";
      url = "https://github.com/valentinmk/asynccmd/commit/12afa60ac07db17e96755e266061f2c88cb545ff.patch";
      hash = "sha256-zhdxEDWn78QTTXkj80VrZpLwfYxIBcBvxjgU+Uaa2lA=";
    })
  ];

  build-system = [ setuptools ];

  # Tests are outdated
  doCheck = false;

  pythonImportsCheck = [ "asynccmd" ];

  meta = with lib; {
    description = "Asyncio implementation of Cmd Python library";
    homepage = "https://github.com/valentinmk/asynccmd";
    changelog = "https://github.com/valentinmk/asynccmd/releases/tag/${version}";
    license = licenses.asl20;
    maintainers = with maintainers; [ fab ];
  };
}
