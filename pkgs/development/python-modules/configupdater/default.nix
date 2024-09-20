{
  lib,
  buildPythonPackage,
  fetchPypi,
  pytestCheckHook,
  setuptools-scm,
}:

buildPythonPackage rec {
  pname = "configupdater";
  version = "3.2";
  format = "setuptools";

  src = fetchPypi {
    inherit version;
    pname = "ConfigUpdater";
    hash = "sha256-n9rFODHBsGKSm/OYtkm4fKMOfxpzXz+/SCBygEEGMGs=";
  };

  postPatch = ''
    substituteInPlace setup.cfg \
      --replace '--cov configupdater --cov-report term-missing' ""
  '';

  nativeBuildInputs = [ setuptools-scm ];

  pythonImportsCheck = [ "configupdater" ];

  nativeCheckInputs = [ pytestCheckHook ];

  meta = with lib; {
    description = "Parser like ConfigParser but for updating configuration files";
    homepage = "https://configupdater.readthedocs.io/en/latest/";
    license = with licenses; [
      mit
      psfl
    ];
    maintainers = with maintainers; [ ris ];
  };
}
