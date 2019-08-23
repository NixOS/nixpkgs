{ stdenv, buildPythonPackage, fetchPypi
, mock, unittest2, nose
, twiggy, requests, offtrac, bugzilla, taskw, dateutil, pytz, keyring, six
, jinja2, pycurl, dogpile_cache, lockfile, click, pyxdg, future }:

buildPythonPackage rec {
  pname = "bugwarrior";
  version = "1.7.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "1pmznka5dxcdjfak0p1yh7lhfbfazmx8g9ysv57lsrkqy4n61qks";
  };

  buildInputs = [ mock unittest2 nose /* jira megaplan */ ];
  propagatedBuildInputs = [
    twiggy requests offtrac bugzilla taskw dateutil pytz keyring six
    jinja2 pycurl dogpile_cache lockfile click pyxdg future
  ];

  # for the moment jira>=0.22 and megaplan>=1.4 are missing for running the test suite.
  doCheck = false;

  meta = with stdenv.lib; {
    homepage =  https://github.com/ralphbean/bugwarrior;
    description = "Sync github, bitbucket, bugzilla, and trac issues with taskwarrior";
    license = licenses.gpl3Plus;
    platforms = platforms.all;
    maintainers = with maintainers; [ pierron ];
  };
}
