{ lib, buildPythonPackage, fetchPypi, isPy3k }:

buildPythonPackage rec {
  version = "3.3";
  pname = "ftputil";

  src = fetchPypi {
    inherit pname version;
    sha256 = "1714w0v6icw2xjx5m54yv2qgkq49qwxwllq4gdb7wkz25iiapr8b";
  };

  disabled = isPy3k;

  meta = with lib; {
    description = "High-level FTP client library (virtual file system and more)";
    homepage    = https://pypi.python.org/pypi/ftputil;
    license     = licenses.bsd2; # "Modified BSD license, says pypi"
  };
}
