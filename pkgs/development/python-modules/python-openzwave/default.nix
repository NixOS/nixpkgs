{
  lib,
  buildPythonPackage,
  fetchPypi,
  isPy3k,
  pkg-config,
  systemd,
  libyaml,
  openzwave,
  cython,
  pyserial,
  six,
  pydispatcher,
  urwid,
}:

buildPythonPackage rec {
  pname = "python-openzwave";
  version = "0.4.19";
  format = "setuptools";

  disabled = !isPy3k;

  src = fetchPypi {
    pname = "python_openzwave";
    inherit version;
    hash = "sha256-a0DHcROD7rNTXPVQTxz0fMGscBjrgg8plkKlonla74Q=";
    extension = "zip";
  };

  nativeBuildInputs = [ pkg-config ];
  buildInputs = [
    systemd
    libyaml
    openzwave
    cython
  ];
  propagatedBuildInputs = [
    six
    urwid
    pydispatcher
    pyserial
  ];

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
