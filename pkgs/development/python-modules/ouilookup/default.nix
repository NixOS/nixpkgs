{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  poetry-core,
  pytestCheckHook,
}:

buildPythonPackage (finalAttrs: {
  pname = "ouilookup";
  version = "0.3.1";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "ndejong";
    repo = "ouilookup";
    tag = finalAttrs.version;
    hash = "sha256-KQMEB5cSG/j0r0vhqDKnRwyGvagkkraG3FCK6cEhavE=";
  };

  build-system = [ poetry-core ];

  nativeCheckInputs = [ pytestCheckHook ];

  pythonImportsCheck = [ "ouilookup" ];

  meta = {
    description = "Library and CLI for looking up MAC address vendors from the IEEE OUI registry";
    homepage = "https://github.com/ndejong/ouilookup";
    license = lib.licenses.bsd2;
    maintainers = with lib.maintainers; [ nimakalantar ];
  };
})
