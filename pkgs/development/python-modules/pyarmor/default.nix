{ lib
, buildPythonPackage
, fetchPypi
}:

buildPythonPackage rec {
  pname = "pyarmor";
  version = "7.7.4";
  format = "wheel";

  src = fetchPypi {
    inherit pname version format;
    sha256 = "sha256-4p4rBWg5Ge5ypirbYC4h/A+TPwHVeq3m1+mNm3VjsIg=";
  };

  # No tests in archive
  doCheck = false;
  pythonImportsCheck = [ "pyarmor" ];

  meta = with lib; {
    description = "A command line tool used to obfuscate python scripts, bind obfuscated scripts to fixed machine or expire obfuscated scripts.";
    homepage = "http://pyarmor.dashingsoft.com";
    license = licenses.unfreeRedistributable;
    maintainers = [ maintainers.mschneider ];
  };
}
