{
  lib,
  buildPythonPackage,
  fetchPypi,
  setuptools,
}:

buildPythonPackage (finalAttrs: {
  pname = "json-merge-patch";
  version = "0.3.0";
  pyproject = true;

  src = fetchPypi {
    pname = "json_merge_patch";
    inherit (finalAttrs) version;
    hash = "sha256-SgItePwvCctJ2Wxkbvw4DTterStcfaviLDkowsLpxOA=";
  };

  build-system = [ setuptools ];

  meta = {
    description = "JSON Merge Patch library";
    mainProgram = "json-merge-patch";
    homepage = "https://github.com/open-contracting/json-merge-patch";
    license = lib.licenses.bsd3;
    maintainers = [ ];
  };
})
