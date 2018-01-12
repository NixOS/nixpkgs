{ stdenv
, buildPythonPackage
, fetchPypi
, darwin
, mock
}:

buildPythonPackage rec {
  pname = "psutil";
  version = "5.4.2";
  name = "${pname}-${version}";

  src = fetchPypi {
    inherit pname version;
    sha256 = "00a1f9ff8d1e035fba7bfdd6977fa8ea7937afdb4477339e5df3dba78194fe11";
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
