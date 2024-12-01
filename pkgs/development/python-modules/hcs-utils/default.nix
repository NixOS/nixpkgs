{
  lib,
  buildPythonPackage,
  fetchPypi,
  pytestCheckHook,
  pythonOlder,
  setuptools,
  six,
  versioneer,
}:

buildPythonPackage rec {
  pname = "hcs-utils";
  version = "2.1.0";
  pyproject = true;

  disabled = pythonOlder "3.9";

  src = fetchPypi {
    pname = "hcs_utils";
    inherit version;
    hash = "sha256-a2xO+hdyJQjgIEcjtmDZLicyz2kzKRjtpEhge5yaa7M=";
  };

  postPatch = ''
    # Remove vendorized versioneer.py
    rm versioneer.py
  '';

  build-system = [
    setuptools
    versioneer
  ];

  dependencies = [ six ];

  nativeCheckInputs = [ pytestCheckHook ];

  disabledTests = [ "test_expand" ];

  meta = with lib; {
    description = "Library collecting some useful snippets";
    homepage = "https://gitlab.com/hcs/hcs_utils";
    license = licenses.isc;
    maintainers = with maintainers; [ lovek323 ];
    platforms = platforms.unix;
  };
}
