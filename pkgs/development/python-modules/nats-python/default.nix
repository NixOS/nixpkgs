{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  fetchpatch,
  poetry-core,
  pythonOlder,
  setuptools,
}:

buildPythonPackage rec {
  pname = "nats-python";
  version = "0.8.0";
  pyproject = true;

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "Gr1N";
    repo = "nats-python";
    rev = "refs/tags/${version}";
    hash = "sha256-7/AGQfPEuSeoRGUXeyDZNbLhapfQa7vhrSPHRruf+sg=";
  };

  patches = [
    # Switch to poetry-core, https://github.com/Gr1N/nats-python/pull/19
    (fetchpatch {
      name = "use-poetry-core.patch";
      url = "https://github.com/Gr1N/nats-python/commit/71b25b324212dccd7fc06ba3914491adba22e83f.patch";
      hash = "sha256-9AUd/anWCAhuD0VdxRm6Ydlst8nttjwfPmqK+S8ON7o=";
    })
  ];

  build-system = [ poetry-core ];

  dependencies = [ setuptools ];

  # Tests require a running NATS server
  doCheck = false;

  pythonImportsCheck = [ "pynats" ];

  meta = with lib; {
    description = "Python client for NATS messaging system";
    homepage = "https://github.com/Gr1N/nats-python";
    changelog = "https://github.com/Gr1N/nats-python/releases/tag/${version}";
    license = with licenses; [ mit ];
    maintainers = with maintainers; [ fab ];
  };
}
