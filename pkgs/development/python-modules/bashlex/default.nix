{ enum-compat
, lib
, buildPythonPackage
, fetchFromGitHub
, nose
, python
}:

buildPythonPackage rec {
  pname = "bashlex";
  version = "0.14";

  src = fetchFromGitHub {
    owner = "idank";
    repo = pname;
    rev = version;
    sha256 = "070spmbf53y18miky5chgky4x5h8kp9czkp7dm173klv9pi2cn0k";
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

  meta = with lib; {
    description = "Python parser for bash";
    license = licenses.gpl3;
    homepage = https://github.com/idank/bashlex;
    maintainers = with maintainers; [ multun ];
  };
}
