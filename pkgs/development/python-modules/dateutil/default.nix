{ stdenv, buildPythonPackage, fetchurl, six }:
buildPythonPackage rec {
  name = "dateutil-${version}";
  version = "2.6.0";

  src = fetchurl {
    url = "mirror://pypi/p/python-dateutil/python-${name}.tar.gz";
    sha256 = "1lhq0hxjc3cfha101q02ld5ijlpfyjn2w1yh7wvpiy367pgzi8k2";
  };

  propagatedBuildInputs = [ six ];

  meta = with stdenv.lib; {
    description = "Powerful extensions to the standard datetime module";
    homepage = http://pypi.python.org/pypi/python-dateutil;
    license = "BSD-style";
  };
}
