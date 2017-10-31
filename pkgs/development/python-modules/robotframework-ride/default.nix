{ stdenv, fetchurl, buildPythonPackage, isPy3k, pygments, wxPython }:

buildPythonPackage rec {
  version = "1.2.3";
  name = "robotframework-ride-${version}";
  disabled = isPy3k;

  src = fetchurl {
    url = "https://robotframework-ride.googlecode.com/files/${name}.tar.gz";
    sha256 = "1lf5f4x80f7d983bmkx12sxcizzii21kghs8kf63a1mj022a5x5j";
  };

  propagatedBuildInputs = [ pygments wxPython ];

  # ride_postinstall.py checks that needed deps are installed and creates a
  # desktop shortcut. We don't really need it and it clutters up bin/ so
  # remove it.
  postInstall = ''
    rm -f "$out/bin/ride_postinstall.py"
  '';

  # error: invalid command 'test'
  doCheck = false;

  meta = with stdenv.lib; {
    description = "Light-weight and intuitive editor for Robot Framework test case files";
    homepage = https://code.google.com/p/robotframework-ride/;
    license = licenses.asl20;
    platforms = platforms.linux;
    maintainers = with maintainers; [ bjornfor ];
  };
}
