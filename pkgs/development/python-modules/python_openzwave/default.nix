{ stdenv, buildPythonPackage, fetchPypi, isPy3k
, pkgconfig
, systemd, libyaml, openzwave, cython
, six, pydispatcher, urwid }:

buildPythonPackage rec {
  pname = "python_openzwave";
  version = "0.4.9";

  disabled = !isPy3k;

  src = fetchPypi {
    inherit pname version;
    sha256 = "97ddd104f52e3a4d7115c3de5d2136631d1f66627fc9b45d56956c3f2b6e0cdb";
    extension = "zip";
  };

  nativeBuildInputs = [ pkgconfig ];
  buildInputs = [ systemd libyaml openzwave cython ];
  propagatedBuildInputs = [ six urwid pydispatcher ];

  # primary location for the .xml files is in /etc/openzwave so we override the
  # /usr/local/etc lookup instead as that allows us to dump new .xml files into
  # /etc/openzwave if needed
  postPatch = ''
    substituteInPlace src-lib/libopenzwave/libopenzwave.pyx \
      --replace /usr/local/etc/openzwave ${openzwave}/etc/openzwave
  '';

  # no tests available
  doCheck = false;

  meta = with stdenv.lib; {
    description = "Python wrapper for the OpenZWave C++ library";
    homepage = https://github.com/OpenZWave/python-openzwave;
    license = licenses.gpl3Plus;
    maintainers = with maintainers; [ etu ];
    inherit (openzwave.meta) platforms;
  };
}
