{ lib, fetchFromGitHub, buildPythonApplication }:

buildPythonApplication {
  name = "gprof2dot-2017-09-19";

  src = fetchFromGitHub {
    owner = "jrfonseca";
    repo = "gprof2dot";
    rev = "2017.09.19";
    sha256 = "1b5wvjv5ykbhz7aix7l3y7mg1hxi0vgak4a49gr92sdlz8blj51v";
  };

  meta = with lib; {
    homepage = https://github.com/jrfonseca/gprof2dot;
    description = "Python script to convert the output from many profilers into a dot graph";
    license = licenses.lgpl3Plus;
    platforms = platforms.linux;
    maintainers = [ maintainers.pmiddend ];
  };
}
