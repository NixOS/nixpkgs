{ stdenv
, buildPythonPackage
, fetchPypi
, darwin
, mock
}:

buildPythonPackage rec {
  pname = "psutil";
  version = "5.4.1";
  name = "${pname}-${version}";

  src = fetchPypi {
    inherit pname version;
    sha256 = "42e2de159e3c987435cb3b47d6f37035db190a1499f3af714ba7af5c379b6ba2";
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
