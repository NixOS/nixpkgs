{ stdenv, buildPythonPackage, glibcLocales, fetchPypi, six, pytz }:

buildPythonPackage rec {
  pname = "feedgenerator";
  version = "1.9.1";

  src = fetchPypi {
    inherit pname version;
    sha256 = "0m6fjnrx3sd0bm6pnbhxxx5ywlwqh8bx0lka386kj28mg3fmm2m2";
  };

  buildInputs = [ glibcLocales ];

  LC_ALL="en_US.UTF-8";

  propagatedBuildInputs = [ six pytz ];

  meta = with stdenv.lib; {
    description = "Standalone version of django.utils.feedgenerator, compatible with Py3k";
    homepage = "https://github.com/dmdm/feedgenerator-py3k.git";
    maintainers = with maintainers; [ ];
  };
}
