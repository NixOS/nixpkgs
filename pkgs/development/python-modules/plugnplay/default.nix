{
  lib,
  buildPythonPackage,
  fetchPypi,
}:
buildPythonPackage rec {
  pname = "plugnplay";
  version = "0.5.4";
  format = "setuptools";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-h34tJQCkWq8x5Rdfn0YYIIjT4tZMHGuf9sd4rg7llMg=";
  };

  # no tests
  doCheck = false;

  pythonImportsCheck = [ "plugnplay" ];

  meta = with lib; {
    description = "Generic plug-in system for python applications";
    homepage = "https://github.com/daltonmatos/plugnplay";
    license = licenses.gpl2Only;
    maintainers = [ ];
  };
}
