{ stdenv, buildPythonPackage, fetchFromGitHub, six, nose, nose-of-yeti
, nose-pattern-exclude, which }:

buildPythonPackage rec {
  pname = "nose-focus";
  version = "0.1.3";

  propagatedBuildInputs = [ six ];

  checkInputs = [ nose nose-of-yeti nose-pattern-exclude which ];

  # PyPI doesn't contain tests so let's use GitHub. See:
  # https://github.com/delfick/nose-focus/issues/4
  #
  # However, the versions aren't tagged on GitHub so need to use a manually
  # checked revision. See: https://github.com/delfick/nose-focus/issues/5
  src = fetchFromGitHub {
    owner = "delfick";
    repo = pname;
    rev = "4dac785ba07ed6e1df61b0fe2854685eef3bd115";
    sha256 = "0gpd4j4433dc5ifh31w08c3bx862md0qm1ix6aam1rz4ayxpq51f";
  };

  checkPhase = ''
    patchShebangs test.sh
    ./test.sh
  '';

  meta = with stdenv.lib; {
    description = "Decorator and plugin to make nose focus on specific tests";
    homepage = https://nose-focus.readthedocs.io/en/latest/;
    license = licenses.wtfpl;
    maintainers = with maintainers; [ jluttine ];
  };
}
