{ lib
, buildPythonPackage
, fetchPypi
, python
}:

buildPythonPackage rec {
  pname = "filetype";
  version = "1.0.4";

  src = fetchPypi {
    inherit pname version;
    sha256 = "366c50d0211798e696626f125134163ac2fff25a70131eec80a1d1a6196c1027";
  };

  checkPhase = ''
    ${python.interpreter} -m unittest discover
  '';

  meta = with lib; {
    description = "Infer file type and MIME type of any file/buffer";
    homepage = https://github.com/h2non/filetype.py;
    license = licenses.mit;
    maintainers = with maintainers; [ dotlambda ];
  };
}
