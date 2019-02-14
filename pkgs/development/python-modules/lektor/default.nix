{ stdenv
, lib
, isPy3k
, buildPythonPackage
, fetchFromGitHub
, click
, watchdog
, exifread
, requests
, mistune
, inifile
, enum34
, Babel
, functools32
, jinja2
, flask
, pyopenssl
, ndg-httpsclient
, pkgs
}:

buildPythonPackage rec {
  pname = "lektor";
  version = "3.1.3";

  src = fetchFromGitHub {
    owner = "lektor";
    repo = "lektor";
    rev = version;
    sha256 = "16qw68rz5q77w84lwyhjpfd3bm4mfrhcjrnxwwnz3vmi610h68hx";
  };

  buildInputs = [ pkgs.glibcLocales ];
  propagatedBuildInputs = [
    click watchdog exifread requests mistune inifile Babel jinja2
    flask pyopenssl ndg-httpsclient
  ] ++ lib.optional (!isPy3k) [enum34 functools32];

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
