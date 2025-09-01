{
  lib,
  buildPythonPackage,
  fetchPypi,
  chardet,
  attrs,
  commoncode,
  pytestCheckHook,
  setuptools-scm,
  pythonOlder,
}:

buildPythonPackage rec {
  pname = "debian-inspector";
  version = "31.1.0";
  pyproject = true;

  disabled = pythonOlder "3.7";

  src = fetchPypi {
    pname = "debian_inspector";
    inherit version;
    hash = "sha256-68+8FwZPEL07bSEizbyXtxpJSvDruvr5qM6t/osWT5k=";
  };

  dontConfigure = true;

  build-system = [ setuptools-scm ];

  dependencies = [
    chardet
    attrs
  ];

  nativeCheckInputs = [
    commoncode
    pytestCheckHook
  ];

  pythonImportsCheck = [ "debian_inspector" ];

  meta = with lib; {
    description = "Utilities to parse Debian package, copyright and control files";
    homepage = "https://github.com/nexB/debian-inspector";
    license = with licenses; [
      asl20
      bsd3
      mit
    ];
    maintainers = [ ];
  };
}
