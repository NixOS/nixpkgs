{
stdenv, pkgs, python, wrapPython, buildPythonPackage,
dateutil, pytest
}:

buildPythonPackage rec {
  pname = "aniso8601";
  name = "${pname}-${version}";
  version = "1.2.0";
  src = pkgs.fetchurl {
    url = "mirror://pypi/a/${pname}/${name}.tar.gz";
    sha256 = "1m2d83rm684xdf54ynfd9lv3slv7bkqq6pcirh2aibvl4pw0092h";
  };
  checkPhase = ''
    py.test
  '';
  meta = with stdenv.lib; {
    description = "A library for parsing ISO 8601 strings";
    homepage    = "https://bitbucket.org/nielsenb/aniso8601";
    license     = licenses.bsd3;
    platforms   = platforms.linux;
  };
  propagatedBuildInputs = [ dateutil pytest ];
  maintainer = with stdenv.lib.maintainers; [ psychomario ];
}
