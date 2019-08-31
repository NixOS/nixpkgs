{ stdenv
, buildPythonPackage
, fetchFromGitHub
, rope
, flake8
, autopep8
, jedi
, importmagic
, black
, mock
, nose
, yapf
, isPy3k
}:

buildPythonPackage rec {
  pname = "elpy";
  version = "1.29.1";

  src = fetchFromGitHub {
    owner = "jorgenschaefer";
    repo = pname;
    rev = version;
    sha256 = "19sd5p03rkp5yibq1ilwisq8jlma02ks2kdc3swy6r27n4hy90xf";
  };

  propagatedBuildInputs = [ flake8 autopep8 jedi importmagic rope yapf ]
    ++ stdenv.lib.optionals isPy3k [ black ];

  checkInputs = [ mock nose ];

  checkPhase = ''
    HOME=$(mktemp -d) nosetests -e "test_should_complete_top_level_modules_for_import"
  '';

  meta = with stdenv.lib; {
    description = "Backend for the elpy Emacs mode";
    homepage = "https://github.com/jorgenschaefer/elpy";
    license = licenses.gpl3;
    maintainers = [ maintainers.costrouc ];
  };

}
