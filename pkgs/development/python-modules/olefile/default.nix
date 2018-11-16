{ stdenv, buildPythonPackage, fetchPypi }:
buildPythonPackage rec {
  pname = "olefile";
  version = "0.45.1";

  src = fetchPypi {
    inherit pname version;
    extension = "zip";
    sha256 = "2b6575f5290de8ab1086f8c5490591f7e0885af682c7c1793bdaf6e64078d385";
  };

  meta = with stdenv.lib; {
    description = "Python package to parse, read and write Microsoft OLE2 files";
    homepage = https://www.decalage.info/python/olefileio;
    # BSD like + reference to Pillow
    license = "http://olefile.readthedocs.io/en/latest/License.html";
  };
}
