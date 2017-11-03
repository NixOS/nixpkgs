{ stdenv, buildPythonPackage, fetchPypi
, nose, chai, simplejson
, dateutil }:

buildPythonPackage rec {
  name = "${pname}-${version}";
  pname = "arrow";
  version = "0.10.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "08n7q2l69hlainds1byd4lxhwrq7zsw7s640zkqc3bs5jkq0cnc0";
  };

  checkPhase = ''
    nosetests --cover-package=arrow
  '';

  buildInputs = [ nose chai simplejson ];
  propagatedBuildInputs = [ dateutil ];

  meta = with stdenv.lib; {
    description = "Python library for date manipulation";
    license     = "apache";
    maintainers = with maintainers; [ thoughtpolice ];
  };
}
