{
  lib,
  fetchurl,
  buildPythonPackage,
  pythonAtLeast,

  pkg-config,

  enlightenment,

  packaging,
  setuptools,

  dbus-python,

  pytestCheckHook,

  directoryListingUpdater,
}:

# Should be bumped along with EFL!

buildPythonPackage rec {
  pname = "python-efl";
  version = "1.26.1";
  pyproject = true;

  # As of 1.26.1, native extensions fail to build with python 3.13+
  disabled = pythonAtLeast "3.13";

  src = fetchurl {
    url = "http://download.enlightenment.org/rel/bindings/python/python-efl-${version}.tar.xz";
    hash = "sha256-3Ns5fhIHihnpDYDnxvPP00WIZL/o1UWLzgNott4GKNc=";
  };

  nativeBuildInputs = [ pkg-config ];

  buildInputs = [ enlightenment.efl ];

  build-system = [
    packaging
    setuptools
  ];

  dependencies = [
    dbus-python
  ];

  preConfigure = ''
    NIX_CFLAGS_COMPILE="$(pkg-config --cflags efl evas) $NIX_CFLAGS_COMPILE"
  '';

  nativeCheckInputs = [
    pytestCheckHook
  ];

  preCheck = ''
    # make sure we load the library from $out instead of the cwd
    # because cwd doesn't contain the built extensions
    rm -r efl/

    patchShebangs tests/ecore/exe_helper.sh

    # use the new name instead of the removed alias
    substituteInPlace tests/evas/test_01_rect.py \
      --replace-fail ".assert_(" ".assertTrue("
  '';

  enabledTestPaths = [ "tests/" ];

  disabledTestPaths = [
    "tests/dbus/test_01_basics.py" # needs dbus daemon
    "tests/ecore/test_09_file_download.py" # uses network
    "tests/ecore/test_11_con.py" # uses network
    "tests/elementary/test_02_image_icon.py" # RuntimeWarning: Setting standard icon failed
  ];

  passthru.updateScript = directoryListingUpdater { };

  meta = with lib; {
    description = "Python bindings for Enlightenment Foundation Libraries";
    homepage = "https://github.com/DaveMDS/python-efl";
    platforms = platforms.linux;
    license = with licenses; [
      gpl3
      lgpl3
    ];
    maintainers = with maintainers; [
      matejc
      ftrvxmtrx
    ];
    teams = [ teams.enlightenment ];
  };
}
