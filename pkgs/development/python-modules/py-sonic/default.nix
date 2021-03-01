{ lib, buildPythonPackage, fetchPypi, isPy27 }:

buildPythonPackage rec {
  pname = "py-sonic";
  version = "0.7.8";
  disabled = isPy27;

  src = fetchPypi {
    inherit pname version;
    sha256 = "1nfpiry1jlgcyxcs5zamyfxwdvdiwg4yw0v8jysfc74hm362rg7d";
  };

  # package has no tests
  doCheck = false;
  pythonImportsCheck = [ "libsonic" ];

  meta = with lib; {
    homepage = "https://github.com/crustymonkey/py-sonic";
    description = "A python wrapper library for the Subsonic REST API";
    license = licenses.gpl3;
    maintainers = with maintainers; [ wenngle ];
  };
}
