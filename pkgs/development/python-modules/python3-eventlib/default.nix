{
  lib,
  fetchFromGitHub,
  buildPythonPackage,
  isPy3k,
  zope-interface,
  twisted,
  greenlet,
}:

buildPythonPackage rec {
  pname = "python3-eventlib";
  version = "0.8.11.3";
  format = "setuptools";

  disabled = !isPy3k;

  src = fetchFromGitHub {
    owner = "AGProjects";
    repo = "python3-eventlib";
    tag = "release-${version}";
    hash = "sha256-YwaASsMAl8jOYtNocoZx/KEVKgDHx9OTJEesJnekWQg=";
  };

  propagatedBuildInputs = [
    zope-interface
    twisted
    greenlet
  ];

  pythonImportsCheck = [ "eventlib" ];

  meta = {
    description = "Networking library written in Python";
    homepage = "https://github.com/AGProjects/python3-eventlib";
    license = lib.licenses.lgpl21Plus;
    maintainers = with lib.maintainers; [ chanley ];
    longDescription = ''
      Eventlib is a networking library written in Python. It achieves high
      scalability by using non-blocking I/O while at the same time retaining
      high programmer usability by using coroutines to make the non-blocking io
      operations appear blocking at the source code level.
    '';
  };
}
