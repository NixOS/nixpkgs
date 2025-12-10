{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  python,
  pytestCheckHook,
}:

buildPythonPackage rec {
  pname = "bashlex";
  version = "0.18";

  format = "setuptools";

  src = fetchFromGitHub {
    owner = "idank";
    repo = "bashlex";
    rev = version;
    hash = "sha256-ddZN91H95RiTLXx4lpES1Dmz7nNsSVUeuFuOEpJ7LQI=";
  };

  # workaround https://github.com/idank/bashlex/issues/51
  preBuild = ''
    ${python.pythonOnBuildForHost.interpreter} -c 'import bashlex'
  '';

  nativeCheckInputs = [ pytestCheckHook ];

  pythonImportsCheck = [ "bashlex" ];

  meta = {
    description = "Python parser for bash";
    license = lib.licenses.gpl3Plus;
    homepage = "https://github.com/idank/bashlex";
    maintainers = with lib.maintainers; [ multun ];
  };
}
