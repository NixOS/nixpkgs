{ stdenv, fetchzip, doxygen, qt5 }:

stdenv.mkDerivation rec {
  name = "signon-${version}";
  version = "8.57";
  src = fetchzip {
    url = "http://signond.accounts-sso.googlecode.com/archive/${version}.zip";
    sha256 = "0q1ncmp27jrwbjkqisf0l63zzpw6bcsx5i4y86xixh8wd5arj87a";
  };

  buildInputs = [ qt5.base ];
  nativeBuildInputs = [ doxygen ];

  configurePhase = ''
    qmake PREFIX=$out LIBDIR=$out/lib CMAKE_CONFIG_PATH=$out/lib/cmake/SignOnQt5
  '';

}
