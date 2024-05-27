{
  lib,
  buildPythonPackage,
  fetchPypi,
  pytestCheckHook,
}:

buildPythonPackage rec {
  pname = "bnunicodenormalizer";
  version = "0.1.6";
  format = "setuptools";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-qVC6+0SnAs25DFzKPHFUOoYPlrRvkGWFptjIVom8wJM=";
  };

  nativeCheckInputs = [ pytestCheckHook ];

  pythonImportsCheck = [ "bnunicodenormalizer" ];

  meta = with lib; {
    description = "Bangla Unicode Normalization Toolkit";
    homepage = "https://github.com/mnansary/bnUnicodeNormalizer";
    license = licenses.mit;
    maintainers = teams.tts.members;
  };
}
