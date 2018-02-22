{ lib, buildPythonPackage, fetchPypi, isPy3k, writeText, configparser, six }:

buildPythonPackage rec {
  pname = "konfig";
  version = "1.1";

  # konfig unconditionaly depend on configparser, even if it is part of
  # the standard library in python 3.2 or above.
  disabled = isPy3k;

  src = fetchPypi {
    inherit pname version;
    sha256 = "7aa4c6463d6c13f4c98c02a998cbef4729da9ad69b676627acc8d3b3efb02b57";
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

  meta = with lib; {
    description = "Yet Another Config Parser";
    homepage    = "https://github.com/mozilla-services/konfig";
    license     = licenses.mpl20;
  };
}
