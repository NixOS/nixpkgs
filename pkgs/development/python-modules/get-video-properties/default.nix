{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  ffmpeg-headless,
}:

buildPythonPackage rec {
  pname = "get-video-properties";
  version = "0.1.1";
  format = "setuptools";

  src = fetchFromGitHub {
    owner = "mvasilkov";
    repo = "python-get-video-properties";
    rev = "944c68addbc27e320ebc6313d3f016fb69b5e880";
    sha256 = "18aslx7amaiw31bl9gambmvzry7hp5nqab6kgp8sg3mz9ih4lzal";
  };

  # no tests
  doCheck = false;

  postPatch = ''
    substituteInPlace videoprops/__init__.py \
      --replace "which('ffprobe')" "'${ffmpeg-headless}/bin/ffprobe'"

    # unused and vulnerable to various CVEs
    rm -r videoprops/binary_dependencies
  '';

  pythonImportsCheck = [ "videoprops" ];

  meta = with lib; {
    description = "Get video properties";
    homepage = "https://github.com/mvasilkov/python-get-video-properties";
    license = licenses.mit;
    maintainers = with maintainers; [ globin ];
  };
}
