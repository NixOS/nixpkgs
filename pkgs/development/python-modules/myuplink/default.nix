{
  lib,
  aiohttp,
  buildPythonPackage,
  fetchFromGitHub,
  pythonOlder,
  setuptools,
}:

buildPythonPackage rec {
  pname = "myuplink";
  version = "0.7.0";
  pyproject = true;

  disabled = pythonOlder "3.9";

  src = fetchFromGitHub {
    owner = "pajzo";
    repo = "myuplink";
    tag = version;
    hash = "sha256-r06aap8FiRslRRgKKSH7vNzpoVn6rX8ZR0oQ0D68xDo=";
  };

  postPatch = ''
    substituteInPlace setup.cfg \
      --replace-fail "%%VERSION_NO%%" "${version}"
  '';

  build-system = [ setuptools ];

  dependencies = [ aiohttp ];

  pythonImportsCheck = [ "myuplink" ];

  meta = with lib; {
    description = "Module to interact with the myUplink API";
    homepage = "https://github.com/pajzo/myuplink";
    changelog = "https://github.com/pajzo/myuplink/releases/tag/${version}";
    license = licenses.mit;
    maintainers = with maintainers; [ fab ];
  };
}
