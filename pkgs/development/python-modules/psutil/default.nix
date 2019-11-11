{ stdenv
, buildPythonPackage
, fetchPypi
, darwin
}:

buildPythonPackage rec {
  pname = "psutil";
  version = "5.6.5";

  src = fetchPypi {
    inherit pname version;
    sha256 = "d051532ac944f1be0179e0506f6889833cf96e466262523e57a871de65a15147";
  };

  # No tests in archive
  doCheck = false;

  buildInputs = [] ++ stdenv.lib.optionals stdenv.isDarwin [ darwin.IOKit ];

  meta = {
    description = "Process and system utilization information interface for python";
    homepage = https://github.com/giampaolo/psutil;
    license = stdenv.lib.licenses.bsd3;
  };
}
