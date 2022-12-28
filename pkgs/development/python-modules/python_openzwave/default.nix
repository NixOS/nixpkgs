{ lib, buildPythonPackage, fetchPypi, isPy3k
, pkg-config
, systemd, libyaml, openzwave, cython, pyserial
, six, pydispatcher, urwid }:

buildPythonPackage rec {
  pname = "python_openzwave";
  version = "0.4.19";

  disabled = !isPy3k;

  src = fetchPypi {
    inherit pname version;
    sha256 = "6b40c7711383eeb3535cf5504f1cf47cc1ac7018eb820f299642a5a2795aef84";
    extension = "zip";
  };

  nativeBuildInputs = [ pkg-config ];
  buildInputs = [ systemd libyaml openzwave cython ];
  propagatedBuildInputs = [ six urwid pydispatcher pyserial ];

  # primary location for the .xml files is in /etc/openzwave so we override the
  # /usr/local/etc lookup instead as that allows us to dump new .xml files into
  # /etc/openzwave if needed
  postPatch = ''
    substituteInPlace src-lib/libopenzwave/libopenzwave.pyx \
      --replace /usr/local/etc/openzwave ${openzwave}/etc/openzwave
  '';

  patches = [ ./cython.patch ];

  # no tests available
  doCheck = false;

  meta = with lib; {
    description = "Python wrapper for the OpenZWave C++ library";
    homepage = "https://github.com/OpenZWave/python-openzwave";
    license = licenses.gpl3Plus;
    maintainers = with maintainers; [ ];
    inherit (openzwave.meta) platforms;
  };
}
