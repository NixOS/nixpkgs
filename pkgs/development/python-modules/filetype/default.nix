{ lib
, buildPythonPackage
, fetchPypi
, python
}:

buildPythonPackage rec {
  pname = "filetype";
  version = "1.0.5";

  src = fetchPypi {
    inherit pname version;
    sha256 = "17a3b885f19034da29640b083d767e0f13c2dcb5dcc267945c8b6e5a5a9013c7";
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
