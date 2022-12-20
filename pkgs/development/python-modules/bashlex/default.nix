{ lib
, buildPythonPackage
, fetchFromGitHub
, python
, pytestCheckHook
}:

buildPythonPackage rec {
  pname = "bashlex";
  version = "0.16";

  format = "setuptools";

  src = fetchFromGitHub {
    owner = "idank";
    repo = pname;
    rev = version;
    hash = "sha256-vpcru/ax872WK3XuRQWTmTD9zRdObn2Bit6kY9ZIQaI=";
  };

  # workaround https://github.com/idank/bashlex/issues/51
  preBuild = ''
    ${python.interpreter} -c 'import bashlex'
  '';

  checkInputs = [
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
