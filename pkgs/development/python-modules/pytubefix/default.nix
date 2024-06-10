{
  lib,
  buildPythonPackage,
  fetchPypi,
  setuptools-scm,
}:

buildPythonPackage rec {
  pname = "pytubefix";
  version = "5.6.3";
  format = "pyproject";

  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-qYNIQhwSZ3ZG3WMY6qCul1OEno1PWgMlfcFSxN3c6aw=";
  };

  nativeBuildInputs = [ setuptools-scm ];

  pythonImportsCheck = [ "pytubefix" ];

  meta = {
    homepage = "https://github.com/JuanBindez/pytubefix";
    description = "Pytube fork with additional features and fixes";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ roshaen ];
  };
}
