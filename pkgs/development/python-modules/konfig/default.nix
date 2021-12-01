{ lib, buildPythonPackage, fetchFromGitHub, isPy3k, writeText, configparser, six, pytest, glibcLocales }:

buildPythonPackage rec {
  pname = "konfig";
  version = "1.1";

  # konfig unconditionaly depend on configparser, even if it is part of
  # the standard library in python 3.2 or above.
  disabled = isPy3k;

  # PyPI tarball is missing utf8.ini, required for tests
  src = fetchFromGitHub {
    owner = "mozilla-services";
    repo = pname;
    rev = version;
    sha256 = "1h780fbrv275dcik4cs3rincza805z6q726b48r4a0qmh5d8160c";
  };

  propagatedBuildInputs = [ configparser six ];

  patches = [ (writeText "konfig.patch" ''
    diff --git a/setup.py b/setup.py
    index 96fd858..bb4db06 100644
    --- a/setup.py
    +++ b/setup.py
    @@ -20,7 +20,7 @@ setup(name='konfig',
           author_email="tarek@mozilla.com",
           include_package_data=True,
           install_requires = [
    -        'configparser', 'argparse', 'six'
    +        'configparser', 'six'
           ],
           zip_safe=False,
           classifiers=classifiers,
  '') ];

  checkInputs = [ pytest glibcLocales ];

  checkPhase = ''
    LC_ALL=en_US.utf8 pytest -v konfig/tests
  '';

  meta = with lib; {
    description = "Yet Another Config Parser";
    homepage    = "https://github.com/mozilla-services/konfig";
    license     = licenses.mpl20;
  };
}
