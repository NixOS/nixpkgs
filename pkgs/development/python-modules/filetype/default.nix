{ lib
, buildPythonPackage
, fetchPypi
, python
}:

buildPythonPackage rec {
  pname = "filetype";
  version = "1.0.7";

  src = fetchPypi {
    inherit pname version;
    sha256 = "19vav4w8vvcnrps1mirjkrv4pr1khwn5ma6m5pgpxd4qip73wffs";
  };

  checkPhase = ''
    ${python.interpreter} -m unittest discover
  '';

  meta = with lib; {
    description = "Infer file type and MIME type of any file/buffer";
    homepage = "https://github.com/h2non/filetype.py";
    license = licenses.mit;
    maintainers = with maintainers; [ dotlambda ];
  };
}
