{ lib
, buildPythonPackage
, fetchPypi
, python
}:

buildPythonPackage rec {
  pname = "filetype";
  version = "1.0.6";

  src = fetchPypi {
    inherit pname version;
    sha256 = "10985zfx90m527binx3fxvm4nsqmlwf0jj8j8mpbxb8wj8ivkllr";
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
