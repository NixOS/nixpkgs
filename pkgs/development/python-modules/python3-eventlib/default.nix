{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  greenlet,
  setuptools,
  twisted,
  zope-interface,
}:

buildPythonPackage (finalAttrs: {
  pname = "python3-eventlib";
  version = "0.3.1";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "AGProjects";
    repo = "python3-eventlib";
    tag = finalAttrs.version;
    hash = "sha256-jN9nn+rI4TJLrEiEIoVxQ3XnXWSws1FenGUfG3doc94=";
  };

  build-system = [ setuptools ];

  dependencies = [
    greenlet
    twisted
    zope-interface
  ];

  pythonImportsCheck = [ "eventlib" ];

  meta = {
    description = "Networking library written in Python";
    homepage = "https://github.com/AGProjects/python3-eventlib";
    longDescription = ''
      Eventlib is a networking library written in Python. It achieves high
      scalability by using non-blocking I/O while at the same time retaining
      high programmer usability by using coroutines to make the non-blocking io
      operations appear blocking at the source code level.
    '';
    license = lib.licenses.lgpl21Plus;
    maintainers = with lib.maintainers; [ chanley ];
  };
})
