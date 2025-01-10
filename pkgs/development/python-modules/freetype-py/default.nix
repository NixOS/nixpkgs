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
  version = "2.3.0";
  pyproject = true;

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-+bZM4ycqXDWNzugkgAoy1wmX+4cqCWWlV63KIPznpdA=";
    extension = "zip";
  };

  patches = [
    (replaceVars ./library-paths.patch {
      freetype = "${freetype.out}/lib/libfreetype${stdenv.hostPlatform.extensions.sharedLibrary}";
    })
  ];

  postPatch = ''
    substituteInPlace pyproject.toml \
      --replace-fail ', "certifi", "cmake"' ""
  '';

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
