{
  lib,
  fetchurl,
  buildPythonPackage,
  pkg-config,
  python,
  dbus-python,
  packaging,
  enlightenment,
  directoryListingUpdater,
}:

# Should be bumped along with EFL!

buildPythonPackage rec {
  pname = "python-efl";
  version = "1.26.1";
  format = "setuptools";

  src = fetchurl {
    url = "http://download.enlightenment.org/rel/bindings/python/${pname}-${version}.tar.xz";
    hash = "sha256-3Ns5fhIHihnpDYDnxvPP00WIZL/o1UWLzgNott4GKNc=";
  };

  nativeBuildInputs = [ pkg-config ];

  buildInputs = [ enlightenment.efl ];

  propagatedBuildInputs = [
    dbus-python
    packaging
  ];

  preConfigure = ''
    NIX_CFLAGS_COMPILE="$(pkg-config --cflags efl evas) $NIX_CFLAGS_COMPILE"
  '';

  preBuild = ''
    ${python.pythonOnBuildForHost.interpreter} setup.py build_ext
  '';

  installPhase = ''
    ${python.pythonOnBuildForHost.interpreter} setup.py install --prefix=$out --single-version-externally-managed
  '';

  doCheck = false;

  passthru.updateScript = directoryListingUpdater { };

  meta = {
    description = "Python bindings for Enlightenment Foundation Libraries";
    homepage = "https://github.com/DaveMDS/python-efl";
    platforms = lib.platforms.linux;
    license = with lib.licenses; [
      gpl3
      lgpl3
    ];
    maintainers =
      with lib.maintainers;
      [
        matejc
        ftrvxmtrx
      ]
      ++ lib.teams.enlightenment.members;
  };
}
