{
  lib,
  buildPythonPackage,
  fetchPypi,
  chmlib,
}:

buildPythonPackage rec {
  pname = "pychm";
  version = "0.8.6";
  format = "setuptools";

  src = fetchPypi {
    inherit pname version;
    sha256 = "0wpn9ijlsmrpyiwg3drmgz4dms1i1i347adgqw37bkrh3vn6yq16";
  };

  buildInputs = [ chmlib ];

  pythonImportsCheck = [ "chm" ];

  meta = with lib; {
    description = "Library to manipulate Microsoft HTML Help (CHM) files";
    homepage = "https://github.com/dottedmag/pychm";
    license = licenses.gpl2Plus;
    maintainers = with maintainers; [ alexshpilkin ];
  };
}
