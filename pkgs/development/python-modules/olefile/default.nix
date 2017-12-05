{ stdenv, buildPythonPackage, fetchPypi }:
buildPythonPackage rec {
  pname = "olefile";
  version = "0.44";
  name = "${pname}-${version}";

  src = fetchPypi {
    inherit pname version;
    extension = "zip";
    sha256 = "1bbk1xplmrhymqpk6rkb15sg7v9qfih7zh23p6g2fxxas06cmwk1";
  };

  meta = with stdenv.lib; {
    description = "Python package to parse, read and write Microsoft OLE2 files";
    homepage = https://www.decalage.info/python/olefileio;
    # BSD like + reference to Pillow
    license = "http://olefile.readthedocs.io/en/latest/License.html";
  };
}
