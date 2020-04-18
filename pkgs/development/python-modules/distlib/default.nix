{ stdenv, buildPythonPackage, fetchPypi }:

buildPythonPackage rec {
  pname = "distlib";
  version = "0.3.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "08fyi2r246733vharl2yckw20rilci28r91mzrnnvcr638inw5if";
    extension = "zip";
  };

  # Tests use pypi.org.
  doCheck = false;

  meta = with stdenv.lib; {
    description = "Low-level components of distutils2/packaging";
    homepage = "https://distlib.readthedocs.io";
    license = licenses.psfl;
    maintainers = with maintainers; [ lnl7 ];
  };
}

