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
  version = "3.12.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "bf5f001e3a7add296e5298240c64db88ba88e5c136bd1fe84fcbd542feb6fccd";
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
