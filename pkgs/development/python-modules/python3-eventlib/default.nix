{ lib, fetchFromGitHub, buildPythonPackage, isPy3k, zope_interface, twisted, greenlet }:

buildPythonPackage rec {
  pname = "python3-eventlib";
  version = "0.3.0";
  format = "setuptools";

  disabled = !isPy3k;

  src = fetchFromGitHub {
    owner = "AGProjects";
    repo = "python3-eventlib";
    rev = version;
    hash = "sha256-LFW3rCGa7A8tk6SjgYgjkLQ+72GE2WN8wG+XkXYTAoQ=";
  };

  propagatedBuildInputs = [ zope_interface twisted greenlet ];

  dontUseSetuptoolsCheck = true;

  pythonImportsCheck = [ "eventlib" ];

  meta = with lib; {
    description = "A networking library written in Python";
    homepage = "https://github.com/AGProjects/python3-eventlib";
    license = licenses.lgpl21Plus;
    maintainers = with maintainers; [ chanley ];
    longDescription = ''
      Eventlib is a networking library written in Python. It achieves high
      scalability by using non-blocking I/O while at the same time retaining
      high programmer usability by using coroutines to make the non-blocking io
      operations appear blocking at the source code level.
    '';
  };
}
