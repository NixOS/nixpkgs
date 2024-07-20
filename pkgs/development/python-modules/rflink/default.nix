{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  async-timeout,
  docopt,
  pyserial,
  pyserial-asyncio,
  setuptools,
  pytestCheckHook,
  pythonOlder,
}:

buildPythonPackage rec {
  pname = "rflink";
  version = "0.0.66";
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "aequitas";
    repo = "python-rflink";
    rev = "refs/tags/${version}";
    hash = "sha256-n6VLa0xX1qewMS7Kv+kiitezWRbRvDJRNuOmA7IV6u0=";
  };

  propagatedBuildInputs = [
    async-timeout
    docopt
    pyserial
    pyserial-asyncio
    setuptools
  ];

  nativeCheckInputs = [ pytestCheckHook ];

  postPatch = ''
    substituteInPlace setup.py \
      --replace "version=version_from_git()" "version='${version}'"
  '';

  pythonImportsCheck = [ "rflink.protocol" ];

  meta = with lib; {
    description = "Library and CLI tools for interacting with RFlink 433MHz transceiver";
    homepage = "https://github.com/aequitas/python-rflink";
    changelog = "https://github.com/aequitas/python-rflink/releases/tag/${version}";
    license = licenses.mit;
    maintainers = with maintainers; [ dotlambda ];
  };
}
