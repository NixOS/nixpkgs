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
  version = "3.12.2";

  src = fetchPypi {
    inherit pname version;
    sha256 = "4b3a1301e57bfd8dce939bf25ef8fbb4b23967fd0f878eede328bdcc41386bac";
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
