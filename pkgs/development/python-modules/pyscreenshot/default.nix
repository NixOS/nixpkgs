{ stdenv, buildPythonPackage, fetchPypi, EasyProcess }:

buildPythonPackage rec {
  pname = "pyscreenshot";
  version = "0.5.1";

  src = fetchPypi {
    inherit pname version;
    sha256 = "171mpyvxqxjzrj9m6xc1qwyvam4ab62jdazkzkkx830wlqbnvv0r";
  };

  propagatedBuildInputs = [ EasyProcess ];

  # disabled test because of cyclic dependency with pyvirtualdisplay
  doCheck = false;

  #checkInputs = [ nose pillow pyvirtualdisplay ];
  #checkPhase = "nosetests -v easy test_scrot.py test_imagemagick.py";

  meta = with stdenv.lib; {
    description = "Python screenshot utility";
    homepage = https://github.com/ponty/pyscreenshot;
    license = licenses.bsd2;
    maintainers = with maintainers; [ gerschtli ];
  };
}
