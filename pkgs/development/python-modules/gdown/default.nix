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
  version = "3.14.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-pxmdfmt3YQnyUWEYadDde6IC5Nm5faNugvn8omLMXSE=";
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
