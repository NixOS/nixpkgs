{ stdenv
, buildPythonPackage
, fetchPypi
, darwin
}:

buildPythonPackage rec {
  pname = "psutil";
  version = "5.6.2";

  src = fetchPypi {
    inherit pname version;
    sha256 = "1v95vb5385qscfdvphv8l2w22bmir3d7yhpi02n58v3mlqy1r3l2";
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
