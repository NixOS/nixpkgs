{
  lib,
  buildPythonPackage,
  fetchPypi,
  setuptools-scm,
}:

buildPythonPackage rec {
  pname = "pytubefix";
  version = "5.7.0";
  format = "pyproject";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-5VnJXQo/VjeGB9Kpazg/MHU8m4Kh/JVd43HXitpk0Mk=";
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
