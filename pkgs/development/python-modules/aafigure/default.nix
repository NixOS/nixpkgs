{
  lib,
  buildPythonPackage,
  fetchPypi,
  pillow,
}:

buildPythonPackage rec {
  pname = "aafigure";
  version = "0.6";
  format = "setuptools";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-SfLB/StXnB//usE4aiZws/b0dcx/9swE2LmEiIwtnh4=";
  };

  propagatedBuildInputs = [ pillow ];

  # error: invalid command 'test'
  doCheck = false;

  # Fix impurity. TODO: Do the font lookup using fontconfig instead of this
  # manual method. Until that is fixed, we get this whenever we run aafigure:
  #   WARNING: font not found, using PIL default font
  patchPhase = ''
    sed -i "s|/usr/share/fonts|/nonexisting-fonts-path|" aafigure/PILhelper.py
  '';

  meta = with lib; {
    description = "ASCII art to image converter";
    mainProgram = "aafigure";
    homepage = "https://launchpad.net/aafigure/";
    license = licenses.bsd2;
    maintainers = with maintainers; [ bjornfor ];
    platforms = platforms.unix;
  };
}
