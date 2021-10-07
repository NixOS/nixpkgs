{ lib
, buildPythonApplication
, fetchPypi
, filelock
, requests
, tqdm
, setuptools
, six
}:

buildPythonApplication rec {
  pname = "gdown";
  version = "4.0.2";

  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-XSYc3mCsFW+x6aZFDNtUE9lHv9vPUvkdsqmbtFX7aQw=";
  };

  propagatedBuildInputs = [ filelock requests tqdm setuptools six ];

  checkPhase = ''
    $out/bin/gdown --help > /dev/null
  '';

  meta = with lib; {
    description = "A CLI tool for downloading large files from Google Drive";
    homepage = "https://github.com/wkentaro/gdown";
    license = licenses.mit;
    maintainers = with maintainers; [ breakds ];
  };
}
