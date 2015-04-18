{ stdenv, fetchurl, pythonPackages, python }:

pythonPackages.buildPythonPackage rec {
  name = "rbtools-0.7.1";
  namePrefix = "";

  src = fetchurl {
    url = "http://downloads.reviewboard.org/releases/RBTools/0.7/RBTools-0.7.1.tar.gz";
    sha256 = "0axi4jf19ia2jwrs3b0xni7v317v03wj35richi111cm3pw6p2gb";
  };

  propagatedBuildInputs = [ python.modules.sqlite3 pythonPackages.six ];
}
