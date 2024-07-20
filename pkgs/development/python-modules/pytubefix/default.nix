{
  lib,
  buildPythonPackage,
  fetchPypi,
  setuptools-scm,
}:

buildPythonPackage rec {
  pname = "pytubefix";
  version = "6.3.4";
  format = "pyproject";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-DV/wH7lT8ivMYQkzZ9JhmA9mihkAnePtzvHjJUFF8cs=";
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
