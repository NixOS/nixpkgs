{ lib
, buildPythonApplication
, fetchPypi
, filelock
, requests
, tqdm
, setuptools
}:

buildPythonApplication rec {
  pname = "gdown";
  version = "3.11.1";

  src = fetchPypi {
    inherit pname version;
    sha256 = "1p023812hh7w7d08njjsfn0xzldl4m73yx8p243yb2q49ypjl6nz";
  };

  propagatedBuildInputs = [ filelock requests tqdm setuptools ];

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
