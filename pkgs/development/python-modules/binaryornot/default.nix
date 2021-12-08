{ lib, buildPythonPackage, fetchFromGitHub, chardet, hypothesis }:

buildPythonPackage rec {
  pname = "binaryornot";
  version = "0.4.4";

  src = fetchFromGitHub {
     owner = "audreyr";
     repo = "binaryornot";
     rev = "0.4.4";
     sha256 = "1k1a77s4ynd7gbnw4cmdnmy5pzbxxvxfcvrv217h0g7zrhzwivm4";
  };

  prePatch = ''
    # TypeError: binary() got an unexpected keyword argument 'average_size'
    substituteInPlace tests/test_check.py \
      --replace "average_size=512" ""
  '';

  propagatedBuildInputs = [ chardet ];

  checkInputs = [ hypothesis ];

  meta = with lib; {
    homepage = "https://github.com/audreyr/binaryornot";
    description = "Ultra-lightweight pure Python package to check if a file is binary or text";
    license = licenses.bsd3;
  };
}
