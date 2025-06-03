{
  lib,
  buildPythonPackage,
  fetchPypi,
  setuptools,
}:

buildPythonPackage rec {
  pname = "json-merge-patch";
  version = "0.3.0";
  pyproject = true;

  src = fetchPypi {
    pname = "json_merge_patch";
    inherit version;
    sha256 = "sha256-SgItePwvCctJ2Wxkbvw4DTterStcfaviLDkowsLpxOA=";
  };

  build-system = [ setuptools ];

  meta = with lib; {
    description = "JSON Merge Patch library";
    mainProgram = "json-merge-patch";
    homepage = "https://github.com/open-contracting/json-merge-patch";
    license = licenses.bsd3;
    maintainers = [ ];
  };
}
