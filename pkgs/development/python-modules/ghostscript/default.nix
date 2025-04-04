{
  buildPythonPackage,
  fetchFromGitLab,
  ghostscript_headless,
  lib,
}:

buildPythonPackage rec {
  pname = "ghostscript";
  version = "0.7";

  src = fetchFromGitLab {
    owner = "pdftools";
    repo = "python-ghostscript";
    tag = "v${version}";
    hash = "sha256-yBJuAnLK/4YDU9PBsSWPQay4pDws3bP+3rCplysq41w=";
  };

  postPatch = ''
    substituteInPlace setup.cfg --replace-fail 'version = attr:ghostscript.__version__' 'version = ${version}'
    substituteInPlace ghostscript/_gsprint.py --replace-fail 'LoadLibrary("libgs.so")' 'LoadLibrary("${ghostscript_headless}/lib/libgs.so")'
  '';

  pythonImportsCheck = [ "ghostscript" ];

  meta = with lib; {
    description = "Python interface to the Ghostscript C-API, both high- and low-level, based on ctypes";
    homepage = "https://gitlab.com/pdftools/python-ghostscript";
    changelog = "https://gitlab.com/pdftools/python-ghostscript/-/blob/v${version}/CHANGES.txt?ref_type=tags";
    license = licenses.gpl3Plus;
    maintainers = with maintainers; [ amarshall ];
  };
}
