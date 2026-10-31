{
  stdenv,
  lib,
  buildPythonPackage,
  fetchPypi,
  setuptools,
  six,
  cmigemo,
  pytestCheckHook,
}:

buildPythonPackage (finalAttrs: {
  pname = "cmigemo";
  version = "0.1.6";
  pyproject = true;

  __structuredAttrs = true;

  src = fetchPypi {
    inherit (finalAttrs) pname version;
    hash = "sha256-cxOqMAf2dgCwZuBKSAXkRFY9FRNB3rMwE1tNzfZERiY=";
  };

  build-system = [ setuptools ];

  dependencies = [ six ];

  preConfigure = ''
    export LDFLAGS="-L${cmigemo}/lib"
    export CPPFLAGS="-I${cmigemo}/include"
    export LD_LIBRARY_PATH="${cmigemo}/lib"
  '';

  postPatch = ''
    sed -i 's~dict_path_base = "/usr/share/cmigemo"~dict_path_base = "/${cmigemo}/share/migemo"~g' test/test_cmigemo.py
  '';

  nativeCheckInputs = [ pytestCheckHook ];

  enabledTestPaths = [ "test/" ];

  pythonImportsCheck = [ "cmigemo" ];

  meta = {
    broken = stdenv.hostPlatform.isDarwin;
    homepage = "https://github.com/mooz/python-cmigemo";
    description = "Pure python binding for C/Migemo";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ illustris ];
  };
})
