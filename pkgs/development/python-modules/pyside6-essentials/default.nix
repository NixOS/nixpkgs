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
  inherit (shiboken6) version;
  format = "wheel";

  src = fetchurl {
    url = "https://files.pythonhosted.org/packages/d8/f7/7a8a0c3a87fc9a898a521ae34aea5806f71f7bef1a0e032a6d954550fcea/PySide6_Essentials-${version}-cp39-abi3-manylinux_2_28_x86_64.whl";
    sha256 = "sha256-4BMjj+QFlrgEBo40rBc1FJQ6Qb+OX7tO38fDCwBDG9U=";
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
