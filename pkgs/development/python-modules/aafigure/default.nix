{ lib, buildPythonPackage, fetchPypi, pillow }:

buildPythonPackage rec {
  pname = "aafigure";
  version = "0.6";
  format = "setuptools";

  src = fetchPypi {
    inherit pname version;
    sha256 = "49f2c1fd2b579c1fffbac1386a2670b3f6f475cc7ff6cc04d8b984888c2d9e1e";
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
    homepage = "https://launchpad.net/aafigure/";
    license = licenses.bsd2;
    maintainers = with maintainers; [ bjornfor ];
    platforms = platforms.unix;
  };
}
