{ stdenv, fetchgit, doxygen, libxml2, qt57 }:

stdenv.mkDerivation rec {
  name = "libqmlbind-${version}";
  version = "0.2.0";

  src = fetchgit {
    url = "https://github.com/seanchas116/libqmlbind";
    rev = "7ca90d1993934cd7748da7ed89484802290b9489";
    sha256 = "00wm9f6c2pa7587m84831171cwrvxp5y5ndcrr8w668nirnzwvsy";
    deepClone = true;
  };

  nativeBuildInputs = [ doxygen ];
  buildInputs = [ libxml2 qt57.full ];

  preBuild = ''
    pushd .
    doxygen Doxyfile
    popd
  '';

  configurePhase = ''
    qmake -r
  '';

  installPhase = ''
    mkdir -pv $out/lib
    cp qmlbind/libqmlbind.so       $out/lib -av
    cp qmlbind/libqmlbind.so.0     $out/lib -av
    cp qmlbind/libqmlbind.so.0.2   $out/lib -av
    cp qmlbind/libqmlbind.so.0.2.0 $out/lib -av

    mkdir -pv $out/include/qmlbind
    cp qmlbind/include/qmlbind/. $out/include/qmlbind -avr

    mkdir -pv $out/share/doc/qmlbind
    cp doc/. $out/share/doc/qmlbind -avr

    mkdir -pv $out/share/qmlbind
    mkdir -pv $out/share/qmlbind/test
    mkdir -pv $out/share/qmlbind/testplugin
    mkdir -pv $out/share/qmlbind/examples
    cp test/. $out/share/qmlbind/test -avr
    cp testplugin/. $out/share/qmlbind/testplugin -avr
    cp examples/. $out/share/qmlbind/examples -avr
  '';

  meta = with stdenv.lib; {
    homepage = https://github.com/seanchas116/libqmlbind;
    description = "C bindings for QML, used for binding to other languages";
  };
}
