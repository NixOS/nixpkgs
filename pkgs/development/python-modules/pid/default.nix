{
  lib,
  buildPythonPackage,
  fetchpatch2,
  fetchPypi,
  pytestCheckHook,
  setuptools,
}:

buildPythonPackage rec {
  pname = "pid";
  version = "3.0.4";
  pyproject = true;

  src = fetchPypi {
    inherit pname version;
    sha256 = "0e33670e83f6a33ebb0822e43a609c3247178d4a375ff50a4689e266d853eb66";
  };

  patches = [
    # apply c9d1550ba2ee73231f8e984d75d808c8cc103748 to remove nose dependency. change is in repo, but hasn't been released on pypi.
    (fetchpatch2 {
      url = "https://github.com/trbs/pid/commit/c9d1550ba2ee73231f8e984d75d808c8cc103748.patch";
      hash = "sha256-2F31LlrJku1xzmI7P+QLyUZ8CzVHx25APp88qwWkZxw=";
    })
  ];

  build-system = [ setuptools ];

  nativeCheckInputs = [ pytestCheckHook ];

  meta = with lib; {
    description = "Pidfile featuring stale detection and file-locking";
    homepage = "https://github.com/trbs/pid/";
    license = licenses.asl20;
  };
}
