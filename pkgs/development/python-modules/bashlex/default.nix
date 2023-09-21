{ lib
, buildPythonPackage
, fetchFromGitHub
, python
, pytestCheckHook
}:

buildPythonPackage rec {
  pname = "bashlex";
  version = "0.18";

  format = "setuptools";

  src = fetchFromGitHub {
    owner = "idank";
    repo = pname;
    rev = version;
    hash = "sha256-ddZN91H95RiTLXx4lpES1Dmz7nNsSVUeuFuOEpJ7LQI=";
  };

  # workaround https://github.com/idank/bashlex/issues/51
  preBuild = ''
    ${python.pythonForBuild.interpreter} -c 'import bashlex'
  '';

  nativeCheckInputs = [
    pytestCheckHook
  ];

  pythonImportsCheck = [ "bashlex" ];

  meta = with lib; {
    description = "Python parser for bash";
    license = licenses.gpl3Plus;
    homepage = "https://github.com/idank/bashlex";
    maintainers = with maintainers; [ multun ];
  };
}
