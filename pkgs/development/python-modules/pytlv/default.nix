{
  lib,
  buildPythonPackage,
  fetchPypi,
  setuptools,
}:

buildPythonPackage rec {
  pname = "pytlv";
  version = "0.71";
  format = "pyproject";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-btxZ0oQzn1ZpwXihHlg6CduLh8nkerLV7SoFyXzJjVY=";
  };

  nativeBuildInputs = [ setuptools ];

  pythonImportsCheck = [ "pytlv" ];

<<<<<<< HEAD
  meta = {
    description = "TLV (tag length lavue) data parser, especially useful for EMV tags parsing";
    homepage = "https://github.com/timgabets/pytlv";
    license = lib.licenses.lgpl2;
    maintainers = with lib.maintainers; [ flokli ];
=======
  meta = with lib; {
    description = "TLV (tag length lavue) data parser, especially useful for EMV tags parsing";
    homepage = "https://github.com/timgabets/pytlv";
    license = licenses.lgpl2;
    maintainers = with maintainers; [ flokli ];
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  };
}
