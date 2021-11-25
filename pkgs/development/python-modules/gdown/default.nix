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
  version = "4.2.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "bd871c125242a9d3691aa74f360b6b5268a58c13991bb2405fdb3ec3028307dc";
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
