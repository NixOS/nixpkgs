{
  lib,
  buildPythonPackage,
  fetchPypi,
  hatchling,
  uv-dynamic-versioning,
  pytestCheckHook,
  sortedcontainers,
}:

buildPythonPackage rec {
  version = "3.2.1";
  pname = "intervaltree";
  pyproject = true;

  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-8/fouut911ufem0zzz7BACWYSo5m4wFtU35SEwxzz+I=";
  };

  build-system = [
    hatchling
    uv-dynamic-versioning
  ];

  dependencies = [ sortedcontainers ];

  nativeCheckInputs = [ pytestCheckHook ];

  preCheck = ''
    rm -rf build
  '';

  meta = {
    description = "Editable interval tree data structure for Python 2 and 3";
    homepage = "https://github.com/chaimleib/intervaltree";
    license = [ lib.licenses.asl20 ];
    maintainers = [ lib.maintainers.bennofs ];
  };
}
