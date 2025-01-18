{
  lib,
  stdenv,
  buildPythonPackage,
  fetchPypi,
  substituteAll,
  setuptools-scm,
  freetype,
  pytestCheckHook,
}:

buildPythonPackage rec {
  pname = "freetype-py";
  version = "2.3.0";
  format = "setuptools";

  src = fetchPypi {
    inherit  pname version;
    hash = "sha256-+bZM4ycqXDWNzugkgAoy1wmX+4cqCWWlV63KIPznpdA=";
    extension = "zip";
  };

  patches = [
    (substituteAll {
      src = ./library-paths.patch;
      freetype = "${freetype.out}/lib/libfreetype${stdenv.hostPlatform.extensions.sharedLibrary}";
    })
  ];

  postPatch = ''
    substituteInPlace pyproject.toml \
      --replace-fail ', "certifi", "cmake"' ""
  '';

  nativeBuildInputs = [ setuptools-scm ];

  propagatedBuildInputs = [ freetype ];

  preCheck = ''
    cd tests
  '';

  nativeCheckInputs = [ pytestCheckHook ];

  pythonImportsCheck = [ "freetype" ];

  meta = with lib; {
    homepage = "https://github.com/rougier/freetype-py";
    description = "FreeType (high-level Python API)";
    license = licenses.bsd3;
    maintainers = with maintainers; [ goertzenator ];
  };
}
