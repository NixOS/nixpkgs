{
  lib,
  buildPythonPackage,
  fetchPypi,
  unittestCheckHook,
  setuptools-scm,
  setuptools,
}:

buildPythonPackage rec {
  pname = "opentypespec";
  version = "1.9.2";
  pyproject = true;

  build-system = [
    setuptools
    setuptools-scm
  ];

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-5j89rMDKxGLLoN88/T7+e0xE8/eOmKN3eDpWxekJGiQ=";
  };

  nativeCheckInputs = [ unittestCheckHook ];
  unittestFlagsArray = [
    "-s"
    "test"
    "-v"
  ];

  meta = with lib; {
    description = "Python library for OpenType specification metadata";
    homepage = "https://github.com/simoncozens/opentypespec-py";
    license = licenses.asl20;
    maintainers = with maintainers; [ danc86 ];
  };
}
