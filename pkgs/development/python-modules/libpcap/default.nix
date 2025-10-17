{
  lib,
  stdenv,
  buildPythonPackage,
  fetchPypi,
  pythonOlder,
  dbus,
  pkgsLibpcap,
  pkg-about,
  setuptools,
  pytestCheckHook,
}:

buildPythonPackage rec {
  pname = "libpcap";
  version = "1.11.0b25";
  pyproject = true;

  disabled = pythonOlder "3.10";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-GzrTqpkiKJjWBuZ7ez707BGZez9wXB96psygDQykO6c=";
  };

  build-system = [ setuptools ];

  # tox is listed in build requirements but not actually used to build
  # keeping it as a requirement breaks the build unnecessarily
  postPatch = ''
    sed -i "/requires/s/, 'tox>=[^']*'//" pyproject.toml
    cat <<EOF >src/libpcap/libpcap.cfg
    [libpcap]
    LIBPCAP = ${lib.getLib pkgsLibpcap}/lib/libpcap${stdenv.hostPlatform.extensions.sharedLibrary}
    EOF
  '';

  buildInputs = [
    dbus.lib
    pkgsLibpcap
    pkg-about
  ];

  preCheck = ''
    pushd tests
  '';
  postCheck = ''
    popd
  '';
  nativeCheckInputs = [ pytestCheckHook ];

  pythonImportsCheck = [ "libpcap" ];

  meta = with lib; {
    description = "Python binding for the libpcap C library";
    longDescription = ''
      Python libpcap module is a low-level binding for libpcap C library.

      It is an effort to allow python programs full access to the API provided by the well known libpcap Unix C library and by its implementations provided under Win32 systems by such packet capture systems as: Npcap, WinPcap

      libpcap is a lightweight Python package, based on the ctypes library.

      It is fully compliant implementation of the original C libpcap from 1.0.0 up to 1.9.0 API and the WinPcap’s 4.1.3 libpcap (1.0.0rel0b) API by implementing whole its functionality in a clean Python instead of C.
    '';
    homepage = "https://github.com/karpierz/libpcap/";
    changelog = "https://github.com/karpierz/libpcap/blob/${version}/CHANGES.rst";
    license = licenses.bsd3;
    teams = [ teams.ororatech ];
  };
}
