{ stdenv, buildPythonPackage, fetchFromGitHub
, pytest, markupsafe }:

buildPythonPackage rec {
  pname = "Jinja2";
  version = "2.9.6";
  name = "${pname}-${version}";

  src = fetchFromGitHub {
    owner = "pallets";
    repo = "jinja";
    rev = version;
    sha256 = "1xxc5vdhz214aawmllv0fi4ak6d7zac662yb7gn1xfgqfz392pg5";
  };

  checkInputs = [ pytest ];
  propagatedBuildInputs = [ markupsafe ];

  checkPhase = ''
    pytest -v
  '';

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
