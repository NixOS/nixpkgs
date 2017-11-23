{ stdenv
, buildPythonPackage
, fetchPypi
, darwin
, mock
}:

buildPythonPackage rec {
  pname = "psutil";
  version = "4.3.0";
  name = "${pname}-${version}";

  src = fetchPypi {
    inherit pname version;
    sha256 = "1w4r09fvn6kd80m5mx4ws1wz100brkaq6hzzpwrns8cgjzjpl6c6";
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
