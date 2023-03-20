{ buildPythonPackage
, meson
, ninja
, pkg-config
, tblite
, cffi
}:

buildPythonPackage rec {
  inherit (tblite) pname version src meta;

  nativeBuildInputs = [ meson ninja pkg-config ];

  buildInputs = [ tblite ];

  propagatedBuildInputs = [ cffi ];

  format = "other";

  configurePhase = ''
    runHook preConfigure

    meson setup build python --prefix=$out
    cd build

    runHook postConfigure
  '';
}
