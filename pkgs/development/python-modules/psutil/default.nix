{ stdenv
, buildPythonPackage
, fetchPypi
, darwin
}:

buildPythonPackage rec {
  pname = "psutil";
  version = "5.6.3";

  src = fetchPypi {
    inherit pname version;
    sha256 = "863a85c1c0a5103a12c05a35e59d336e1d665747e531256e061213e2e90f63f3";
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
