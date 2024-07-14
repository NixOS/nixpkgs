{
  lib,
  pythonOlder,
  buildPythonPackage,
  fetchPypi,
  unittestCheckHook,
}:

buildPythonPackage rec {
  pname = "fastimport";
  version = "0.9.14";
  format = "setuptools";

  disabled = pythonOlder "3.5";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-asmd2k57CzroMVB7bQCUgC5t2ViR/q/ejMXEBbbBSco=";
  };

  nativeCheckInputs = [ unittestCheckHook ];

  pythonImportsCheck = [ "fastimport" ];

  meta = with lib; {
    homepage = "https://github.com/jelmer/python-fastimport";
    description = "VCS fastimport/fastexport parser";
    maintainers = with maintainers; [ koral ];
    license = licenses.gpl2Plus;
  };
}
