{ autoPatchelfHook
, buildPythonPackage
, fetchurl
, lib
, shiboken6

  # libraries
, gtk3
, libxkbcommon
, mysql80
, postgresql
, qt6
, unixODBC
}:

buildPythonPackage rec {
  pname = "pyside6-essentials";
  version = "6.6.0";
  format = "wheel";

  src = fetchurl {
    url = "https://files.pythonhosted.org/packages/e2/f0/09e8e38a51f705eecda1202cb51a9fcc7affb0f9fd3be44bf58ce25528dc/PySide6_Essentials-${version}-cp38-abi3-manylinux_2_28_x86_64.whl";
    sha256 = "sha256-YChGQWGflk4ctNU88xadejheA3i3Ttt1YQkY0q6hxOU=";
  };

  propagatedBuildInputs = [
    shiboken6
  ];

  nativeBuildInputs = [
    autoPatchelfHook
  ];

  buildInputs = [
    gtk3 # libgtk-3.so.0 and more
    libxkbcommon # libxkbcommon.so.0
    mysql80 # libmysqlclient.so.21
    postgresql.lib # libpq.so.5
    qt6.full # libGL.so.1, and more
    unixODBC # libodbc.so.2
  ];

  autoPatchelfIgnoreMissingDeps = [ "libmimerapi.so" ]; # not in nixpkgs yet

  meta = with lib; {
    description = "Python bindings for Qt (Essentials)";
    homepage = "https://www.pyside.org";
    license = licenses.lgpl3; # unsure which LGPL version
    maintainers = with maintainers; [ getpsyched ];
  };
}
