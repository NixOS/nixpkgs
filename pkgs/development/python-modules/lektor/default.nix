{ stdenv
, buildPythonPackage
, fetchgit
, click
, watchdog
, exifread
, requests
, mistune
, inifile
, Babel
, jinja2
, flask
, pyopenssl
, ndg-httpsclient
, pkgs
}:

buildPythonPackage rec {
  pname = "lektor";
  version = "2.3";

  src = fetchgit {
    url = "https://github.com/lektor/lektor";
    rev = "refs/tags/${version}";
    sha256 = "1n0ylh1sbpvi9li3g6a7j7m28njfibn10y6s2gayjxwm6fpphqxy";
  };

  buildInputs = [ pkgs.glibcLocales ];
  propagatedBuildInputs = [
    click watchdog exifread requests mistune inifile Babel jinja2
    flask pyopenssl ndg-httpsclient
  ];

  LC_ALL="en_US.UTF-8";

  # No tests included in archive
  doCheck = false;

  meta = with stdenv.lib; {
    description = "A static content management system";
    homepage    = "https://www.getlektor.com/";
    license     = licenses.bsd0;
    maintainers = with maintainers; [ vozz ];
  };

}
