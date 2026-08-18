{
  lib,
  buildPythonPackage,
  fetchPypi,
  unittestCheckHook,
}:

buildPythonPackage rec {
  pname = "fastimport";
  version = "0.9.16";
  format = "setuptools";

  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-agpvtWqjYH3nGtTnq9VRr+m9rJS6uNLddNjg+Y9S414=";
  };

  nativeCheckInputs = [ unittestCheckHook ];

  pythonImportsCheck = [ "fastimport" ];

  meta = {
    homepage = "https://github.com/jelmer/python-fastimport";
    description = "VCS fastimport/fastexport parser";
    maintainers = with lib.maintainers; [ koral ];
    license = lib.licenses.gpl2Plus;
  };
}
