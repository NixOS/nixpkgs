{ stdenv, buildPythonPackage, fetchPypi, pillow }:

buildPythonPackage rec {
  pname = "aafigure";
  version = "0.5";
  name = "${pname}-${version}";

  src = fetchPypi {
    inherit pname version;
    sha256 = "090c88beb091d28a233f854e239713aa15d8d1906ea16211855345c912e8a091";
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

  meta = with stdenv.lib; {
    description = "ASCII art to image converter";
    homepage = https://launchpad.net/aafigure/;
    license = licenses.bsd2;
    maintainers = with maintainers; [ bjornfor ];
    platforms = platforms.linux;
  };
}
