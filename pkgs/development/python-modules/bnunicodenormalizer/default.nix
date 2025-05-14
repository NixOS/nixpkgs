{
  lib,
  buildPythonPackage,
  fetchPypi,
  pytestCheckHook,
}:

buildPythonPackage rec {
  pname = "bnunicodenormalizer";
  version = "0.1.7";
  format = "setuptools";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-hqNInMgcc9KvtOJlvS0Ni8UvyKI3TiEMiZ4CYJQLwJE=";
  };

  nativeCheckInputs = [ pytestCheckHook ];

  pythonImportsCheck = [ "bnunicodenormalizer" ];

  meta = with lib; {
    description = "Bangla Unicode Normalization Toolkit";
    homepage = "https://github.com/mnansary/bnUnicodeNormalizer";
    license = licenses.mit;
    teams = [ teams.tts ];
  };
}
