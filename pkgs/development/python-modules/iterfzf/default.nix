{ lib, buildPythonPackage, fzf, fetchPypi }:

buildPythonPackage rec {
  pname = "iterfzf";
  version = "0.5.0.20.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "0by5pk7w1j2xzhj4l0nw09sz9025pdskbf1b7k87kfkwgbc08vrb";
  };

  prePatch = ''
    substituteInPlace iterfzf/__init__.py \
                      --replace "EXECUTABLE_NAME = 'fzf.exe' if sys.platform == 'win32' else 'fzf'" \
                      "EXECUTABLE_NAME = 'fzf.exe' if sys.platform == 'win32' else '${fzf}/bin/fzf'"
  '';

  pythonImportsCheck = [ "iterfzf" ];

  meta = with lib; {
    description = "Pythonic interface to fzf";
    homepage = "https://github.com/dahlia/iterfzf";
    license = licenses.gpl3Plus;
    maintainers = with maintainers; [ swflint ];
  };

}
