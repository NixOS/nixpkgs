{
  lib,
  buildPythonPackage,
  fetchPypi,
  nix-update-script,
  poetry-core,
  six,
}:

buildPythonPackage (finalAttrs: {
  pname = "bbpb";
  version = "1.4.2";
  pyproject = true;

  __structuredAttrs = true;

  src = fetchPypi {
    inherit (finalAttrs) pname version;
    hash = "sha256-A0RpkbxQDPyd0gSebMlImXnhV8Xst5PieTarPVedNJY=";
  };

  build-system = [ poetry-core ];

  dependencies = [ six ];

  pythonImportsCheck = [ "blackboxprotobuf" ];

  # Would require to switch to GitHub as source
  doCheck = false;

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Library for working with protobuf messages without a protobuf type definition";
    homepage = "https://pypi.org/project/bbpb";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ fab ];
  };
})
