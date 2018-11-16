{ stdenv, fetchPypi, buildPythonPackage
, lxml, pycryptodome, colorama }:

buildPythonPackage rec {
  pname = "libkeepass";
  version = "0.3.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "3ed79ea786f7020b14b83c082612ed8fbcc6f8edf65e1697705837ab9e40e9d7";
  };

  propagatedBuildInputs = [ lxml pycryptodome colorama ];

  # No tests on PyPI
  doCheck = false;

  meta = with stdenv.lib; {
    homepage = https://github.com/libkeepass/libkeepass;
    description = "A library to access KeePass 1.x/KeePassX (v3) and KeePass 2.x (v4) files";
    license = licenses.gpl2Plus;
    maintainers = with maintainers; [ jqueiroz ];
  };
}
