{ lib
, buildPythonPackage
, fetchPypi
, python
}:

buildPythonPackage rec {
  pname = "filetype";
  version = "1.0.3";

  src = fetchPypi {
    inherit pname version;
    sha256 = "74ccbd9ca5c95aad5665eee2f173fb1930226a12f05b0bc7380b1d456a86fcdf";
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
