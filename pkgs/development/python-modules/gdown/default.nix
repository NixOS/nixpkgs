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
  version = "3.13.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "d5f9389539673875712beba4936c4ace95d24324953c6f0408a858c534c0bf21";
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
