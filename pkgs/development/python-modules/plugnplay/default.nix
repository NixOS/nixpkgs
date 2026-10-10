{
  lib,
  buildPythonPackage,
  fetchPypi,
}:
buildPythonPackage (finalAttrs: {
  pname = "plugnplay";
  version = "0.5.4";
  format = "setuptools";

  src = fetchPypi {
    inherit (finalAttrs) pname version;
    hash = "sha256-h34tJQCkWq8x5Rdfn0YYIIjT4tZMHGuf9sd4rg7llMg=";
  };

  # no tests
  doCheck = false;

  pythonImportsCheck = [ "plugnplay" ];

  meta = {
    description = "Generic plug-in system for python applications";
    homepage = "https://github.com/daltonmatos/plugnplay";
    license = lib.licenses.gpl2Only;
    maintainers = [ ];
  };
})
