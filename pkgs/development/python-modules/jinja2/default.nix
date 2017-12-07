{ stdenv, buildPythonPackage, fetchPypi
, markupsafe }:

buildPythonPackage rec {
  pname = "Jinja2";
  version = "2.9.6";
  name = "${pname}-${version}";

  src = fetchPypi {
    inherit pname version;
    sha256 = "1zzrkywhziqffrzks14kzixz7nd4yh2vc0fb04a68vfd2ai03anx";
  };

  propagatedBuildInputs = [ markupsafe ];

  # No tests included
  doCheck = false;

  meta = with stdenv.lib; {
    homepage = http://jinja.pocoo.org/;
    description = "Stand-alone template engine";
    license = licenses.bsd3;
    longDescription = ''
      Jinja2 is a template engine written in pure Python. It provides a
      Django inspired non-XML syntax but supports inline expressions and
      an optional sandboxed environment.
      '';
    platforms = platforms.all;
    maintainers = with maintainers; [ pierron garbas sjourdois ];
  };
}
