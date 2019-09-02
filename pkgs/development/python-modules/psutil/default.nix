{ stdenv
, buildPythonPackage
, fetchPypi
, darwin
}:

buildPythonPackage rec {
  pname = "psutil";
  version = "5.5.1";

  src = fetchPypi {
    inherit pname version;
    sha256 = "045qaqvn6k90bj5bcy259yrwcd2afgznaav3sfhphy9b8ambzkkj";
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
