{ lib
, stdenv
, buildPythonPackage
, fetchPypi
, pythonOlder
, dbus
, pkgsLibpcap
, pkg-about
, setuptools
, tox
}:

buildPythonPackage rec {
  pname = "libpcap";
  version = "1.11.0b7";
  format = "pyproject";

  disabled = pythonOlder "3.7";

  src = fetchPypi {
    inherit pname version;
    extension = "zip";
    hash = "sha256-gEWFqmeOJTVHdjcSOxfVLZtrNSO3CTY1L2VcXOu7q7k=";
  };

  nativeBuildInputs = [
    setuptools
    tox
  ];

  postPatch = ''
    cat <<EOF >src/libpcap/libpcap.cfg
    [libpcap]
    LIBPCAP = ${pkgsLibpcap}/lib/libpcap${stdenv.hostPlatform.extensions.sharedLibrary}
    EOF
  '';

  propagatedBuildInputs = [
    dbus.lib
    pkgsLibpcap
    pkg-about
  ];

  # Project has tests, but I can't get them to run even outside of nix
  doCheck = false;

  pythonImportsCheck = [
    "libpcap"
  ];

  meta = with lib; {
    description = "Python binding for the libpcap C library";
    longDescription = ''
      Python libpcap module is a low-level binding for libpcap C library.

      It is an effort to allow python programs full access to the API provided by the well known libpcap Unix C library and by its implementations provided under Win32 systems by such packet capture systems as: Npcap, WinPcap

      libpcap is a lightweight Python package, based on the ctypes library.

      It is fully compliant implementation of the original C libpcap from 1.0.0 up to 1.9.0 API and the WinPcap’s 4.1.3 libpcap (1.0.0rel0b) API by implementing whole its functionality in a clean Python instead of C.
    '';
    homepage = "https://github.com/karpierz/libpcap/";
    license = licenses.bsd3;
    maintainers = [ teams.ororatech ];
  };
}
