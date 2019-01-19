{ buildPythonPackage, fetchPypi, isPy3k
, six, jaraco_logging, jaraco_text, jaraco_stream, pytz, jaraco_itertools
, setuptools_scm }:

buildPythonPackage rec {
  pname = "irc";
  version = "17.0";

  disabled = !isPy3k;

  src = fetchPypi {
    inherit pname version;
    sha256 = "f9c5fcb72dd230e1387fd4a0114a1935605e0f59ac09dec962313baed74e1365";
  };

  doCheck = false;

  buildInputs = [ setuptools_scm ];
  propagatedBuildInputs = [
    six
    jaraco_logging
    jaraco_text
    jaraco_stream
    pytz
    jaraco_itertools
  ];
}
