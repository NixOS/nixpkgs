{ stdenv, fetchurl, python, buildPythonPackage, nose, future, coverage }:

buildPythonPackage rec {
  pname = "PyZufall";
  version = "0.13.2";
  name = "${pname}-${version}";

  src = fetchurl {
    url = "mirror://pypi/${builtins.substring 0 1 pname}/${pname}/${name}.tar.gz";
    sha256 = "1jffhi20m82fdf78bjhncbdxkfzcskrlipxlrqq9741xdvrn14b5";
  };

  # disable tests due to problem with nose
  # https://github.com/nose-devs/nose/issues/1037
  doCheck = false;

  buildInputs = [ nose coverage ];
  propagatedBuildInputs = [ future ];

  checkPhase = ''
    ${python.interpreter} setup.py nosetests
  '';

  meta = with stdenv.lib; {
    homepage = https://pyzufall.readthedocs.io/de/latest/;
    description = "Library for generating random data and sentences in german language";
    license = licenses.gpl3Plus;
    maintainers = with maintainers; [ davidak ];
  };
}
