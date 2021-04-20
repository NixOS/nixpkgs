{ lib, buildPythonPackage, fetchFromPyPI }:
buildPythonPackage rec {
  pname = "olefile";
  version = "0.46";

  src = fetchFromPyPI {
    inherit pname version;
    extension = "zip";
    sha256 = "133b031eaf8fd2c9399b78b8bc5b8fcbe4c31e85295749bb17a87cba8f3c3964";
  };

  meta = with lib; {
    description = "Python package to parse, read and write Microsoft OLE2 files";
    homepage = "https://www.decalage.info/python/olefileio";
    # BSD like + reference to Pillow
    license = "http://olefile.readthedocs.io/en/latest/License.html";
  };
}
