{
  lib,
  buildPythonPackage,
  pyee,
  fetchPypi,
  setuptools-scm,
}:

buildPythonPackage rec {
  pname = "python_ffmpeg";
  version = "2.0.12";
  pyproject = true;

  src = fetchPypi {
    inherit pname version;
    sha256 = "GayAr1oGSi9TwkWvGpCbLXZI6gRVANltO81Qe4jUPcc=";
  };

  propagatedBuildInputs = [ pyee ];

  nativeBuildInputs = [ setuptools-scm ];
  pythonImportCheck = [ "ffmpeg" ];

  meta = {
    homepage = "https://github.com/jonghwanhyeon/python-ffmpeg";
    description = "Python binding for FFmpeg which provides sync and async APIs";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ roshaen ];
  };
}
