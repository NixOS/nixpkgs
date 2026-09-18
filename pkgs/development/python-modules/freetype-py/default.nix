{
  lib,
  stdenv,
  buildPythonPackage,
  fetchPypi,
  replaceVars,
  setuptools,
  setuptools-scm,
  freetype,
  pytestCheckHook,
}:

buildPythonPackage rec {
  pname = "freetype-py";
  version = "2.5.1";
  pyproject = true;

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-z+JoahdNDdPXGp2O6b9qLCP1hyOFz4zp8kr4PQduL70=";
    extension = "zip";
  };

  patches = [
    (replaceVars ./library-paths.patch {
      freetype = "${freetype.out}/lib/libfreetype${stdenv.hostPlatform.extensions.sharedLibrary}";
    })
  ];

  build-system = [
    setuptools
    setuptools-scm
  ];

  dependencies = [ freetype ];

  preCheck = ''
    cd tests
  '';

  nativeCheckInputs = [ pytestCheckHook ];

  pythonImportsCheck = [ "freetype" ];

  meta = {
    homepage = "https://github.com/rougier/freetype-py";
    description = "FreeType (high-level Python API)";
    license = lib.licenses.bsd3;
    maintainers = with lib.maintainers; [ goertzenator ];
  };
}
