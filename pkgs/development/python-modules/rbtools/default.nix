{ stdenv, fetchurl, pythonPackages, python }:

pythonPackages.buildPythonPackage rec {
  name = "rbtools-0.7.2";
  namePrefix = "";

  src = fetchurl {
    url = "http://downloads.reviewboard.org/releases/RBTools/0.7/RBTools-0.7.2.tar.gz";
    sha256 = "1ng8l8cx81cz23ls7fq9wz4ijs0zbbaqh4kj0mj6plzcqcf8na4i";
  };

  propagatedBuildInputs = [ python.modules.sqlite3 pythonPackages.six ];

  meta = {
    maintainers = [ stdenv.lib.maintainers.iElectric ];
  };
}
