{ enum-compat
, lib
, buildPythonPackage
, fetchFromGitHub
, nose
, python
}:

buildPythonPackage rec {
  pname = "bashlex";
  version = "0.15";

  src = fetchFromGitHub {
    owner = "idank";
    repo = pname;
    rev = version;
    sha256 = "sha256-kKVorAIKlyC9vUzLOlaZ/JrG1kBBRIvLwBmHNj9nx84=";
  };

  checkInputs = [ nose ];
  propagatedBuildInputs = [ enum-compat ];

  # workaround https://github.com/idank/bashlex/issues/51
  preBuild = ''
    ${python.interpreter} -c 'import bashlex'
  '';

  checkPhase = ''
    ${python.interpreter} -m nose --with-doctest
  '';

  pythonImportsCheck = [ "bashlex" ];

  meta = with lib; {
    description = "Python parser for bash";
    license = licenses.gpl3Plus;
    homepage = "https://github.com/idank/bashlex";
    maintainers = with maintainers; [ multun ];
  };
}
