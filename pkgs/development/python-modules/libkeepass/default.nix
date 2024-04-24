{ lib, fetchPypi, buildPythonPackage
, lxml, pycryptodome, colorama }:

buildPythonPackage rec {
  pname = "libkeepass";
  version = "0.3.1.post1";
  format = "setuptools";

  src = fetchPypi {
    inherit pname version;
    sha256 = "0pwg7n9xqcjia1qmz6g48h5s31slh3mxmcqag73gq4zhl4xb6bai";
  };

  propagatedBuildInputs = [ lxml pycryptodome colorama ];

  # No tests on PyPI
  doCheck = false;

  meta = with lib; {
    homepage = "https://github.com/libkeepass/libkeepass";
    description = "A library to access KeePass 1.x/KeePassX (v3) and KeePass 2.x (v4) files";
    license = licenses.gpl2Plus;
    maintainers = with maintainers; [ jqueiroz ];
  };
}
