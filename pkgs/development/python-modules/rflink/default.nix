{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  docopt,
  pyserial,
  pyserial-asyncio-fast,
  setuptools,
  pytestCheckHook,
}:

buildPythonPackage rec {
  pname = "rflink";
  version = "0.0.67";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "aequitas";
    repo = "python-rflink";
    tag = version;
    hash = "sha256-LAmn9/l+J++CvRa5gypuoQ41mZVSoVqbPpbqVSP6CN4=";
  };

  build-system = [ setuptools ];

  dependencies = [
    docopt
    pyserial
    pyserial-asyncio-fast
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
    changelog = "https://github.com/aequitas/python-rflink/releases/tag/${src.tag}";
    license = licenses.mit;
    maintainers = with maintainers; [ dotlambda ];
  };
}
