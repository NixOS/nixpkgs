{ buildPythonPackage, fetchPypi
, six, jaraco_logging, jaraco_text, jaraco_stream, pytz, jaraco_itertools
, setuptools_scm }:

buildPythonPackage rec {
  pname = "irc";
  version = "16.4";

  src = fetchPypi {
    inherit pname version;
    sha256 = "0l2fh2aqs54w4xihckgyz575qkd6mgzbp3zll4g0z9j6h88ghqf1";
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
