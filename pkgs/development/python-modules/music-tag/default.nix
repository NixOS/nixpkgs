{
  lib,
  buildPythonPackage,
  fetchPypi,
  mutagen,
  pytestCheckHook,
}:

buildPythonPackage rec {
  pname = "music-tag";
  version = "0.4.3";
  format = "setuptools";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-Cqtubu2o3w9TFuwtIZC9dFYbfgNWKrCRzo1Wh828//Y=";
  };

  propagatedBuildInputs = [ mutagen ];

  checkInputs = [ pytestCheckHook ];

  enabledTestPaths = [ "test" ];

  # Tests fail: ModuleNotFoundError: No module named '_test_common'
  doCheck = false;

  pythonImportsCheck = [ "music_tag" ];

  meta = with lib; {
    description = "Simple interface to edit audio file metadata";
    homepage = "https://github.com/KristoforMaynard/music-tag";
    license = licenses.mit;
    maintainers = with maintainers; [ onny ];
  };
}
