{ stdenv
, buildPythonPackage
, fetchFromGitHub
}:

buildPythonPackage {
  pname = "bugz-0.9.3";
  version = "0.13";

  src = fetchFromGitHub {
    owner = "williamh";
    repo = "pybugz";
    rev = "0.13";
    sha256 = "1nw07q7r078dp82rcrhvvnhmnaqjx6f8a6cdjgrsiy6fryrx9dwz";
  };

  doCheck = false;

  meta = with stdenv.lib; {
    homepage = "https://github.com/williamh/pybugz";
    description = "Command line interface for Bugzilla";
    license = licenses.gpl2;
    maintainers = [ maintainers.costrouc ];
  };

}
