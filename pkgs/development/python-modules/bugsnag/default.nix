{ stdenv
, buildPythonPackage
, fetchPypi
, pythonOlder
, six
, webob
}:

buildPythonPackage rec {
  pname = "bugsnag";
  version = "4.0.1";
  disabled = pythonOlder "3.5";

  src = fetchPypi {
    inherit pname version;
    sha256 = "01c2186f6c2a6f801b66d8fc73b8986bd2d4931a6ab40b720e5fd0b66757facc";
  };

  propagatedBuildInputs = [ six webob ];

  # no tests
  doCheck = false;

  meta = with stdenv.lib; {
    description = "Automatic error monitoring for django, flask, etc.";
    homepage = "https://www.bugsnag.com";
    license = licenses.mit;
    platforms = platforms.unix;
  };
}
