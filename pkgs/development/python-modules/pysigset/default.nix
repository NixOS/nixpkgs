{
stdenv, pkgs, python, wrapPython, buildPythonPackage
}:

buildPythonPackage rec {
  pname = "pysigset";
  name = "${pname}-${version}";
  version = "0.2.1";
  src = pkgs.fetchurl {
    url = "mirror://pypi/p/${pname}/${name}.tar.gz";
    sha256 = "0f3g705r2zb09xvz81kmci4iza7ph2gqydmmv0nxqfs50msn3pw1";
  };
  meta = with stdenv.lib; {
    description = "Python blocking/suspending signals under Linux/OSX using ctypes sigprocmask access";
    homepage    = "https://github.com/ossobv/pysigset";
    license     = licenses.gpl3Plus;
    platforms   = platforms.linux;
  };
  maintainer = with stdenv.lib.maintainers; [ psychomario ];
}
