{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  setuptools,
  pyserial,
}:

buildPythonPackage rec {
  pname = "asyncserial";
  version = "1.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "m-labs";
    repo = "asyncserial";
    tag = version;
    hash = "sha256-ZHzgJnbsDVxVcp09LXq9JZp46+dorgdP8bAiTB59K28=";
  };

  build-system = [ setuptools ];

  dependencies = [ pyserial ];

  pythonImportsCheck = [ "asyncserial" ];

  meta = {
    description = "asyncio support for pyserial";
    homepage = "https://github.com/m-labs/asyncserial";
    license = lib.licenses.bsd2;
    maintainers = with lib.maintainers; [ doronbehar ];
  };
}
