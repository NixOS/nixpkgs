{ stdenv, buildPythonPackage, fetchPypi
, mock, unittest2, nose
, twiggy, requests, offtrac, bugzilla, taskw, dateutil, pytz, keyring, six
, jinja2, pycurl, dogpile_cache, lockfile, click, pyxdg, future15 }:

buildPythonPackage rec {
  pname = "bugwarrior";
  version = "1.6.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "cfa4fac19b4f4638928347b8fe192315f72813c3e8ed668867e5891338c7e4ec";
  };

  buildInputs = [ mock unittest2 nose /* jira megaplan */ ];
  propagatedBuildInputs = [
    twiggy requests offtrac bugzilla taskw dateutil pytz keyring six
    jinja2 pycurl dogpile_cache lockfile click pyxdg future15
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
