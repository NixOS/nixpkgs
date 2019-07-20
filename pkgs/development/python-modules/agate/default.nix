{ lib, fetchFromGitHub, buildPythonPackage, isPy3k
, six, pytimeparse, parsedatetime, Babel
, isodate, python-slugify, leather
, glibcLocales, nose, lxml, cssselect, unittest2 }:

buildPythonPackage rec {
  pname = "agate";
  version = "1.6.1";

  # PyPI tarball does not include all test files
  # https://github.com/wireservice/agate/pull/716
  src = fetchFromGitHub {
    owner = "wireservice";
    repo = pname;
    rev = version;
    sha256 = "077zj8xad8hsa3nqywvf7ircirmx3krxdipl8wr3dynv3l3khcpl";
  };

  propagatedBuildInputs = [
    six pytimeparse parsedatetime Babel
    isodate python-slugify leather
  ];

  checkInputs = [ glibcLocales nose lxml cssselect ]
    ++ lib.optional (!isPy3k) unittest2;

  checkPhase = ''
    LC_ALL="en_US.UTF-8" nosetests tests
  '';

  meta = with lib; {
    description = "A Python data analysis library that is optimized for humans instead of machines";
    homepage    = https://github.com/wireservice/agate;
    license     = with licenses; [ mit ];
    maintainers = with maintainers; [ vrthra ];
  };
}
