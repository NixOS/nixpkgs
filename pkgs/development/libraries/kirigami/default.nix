{ stdenv, fetchurl, cmake, extra-cmake-modules, pkgconfig
, plasma-framework, qtbase, qttranslations
, qtquickcontrols ? null
, qtquickcontrols2 ? null }:

let
  pname = "kirigami";

  generic = { name, version, sha256, qtqc, broken }:
  stdenv.mkDerivation rec {
    inherit name version;

    src = fetchurl {
      url = "mirror://kde/stable/${pname}/${name}.tar.xz";
      inherit sha256;
    };

    buildInputs = [ plasma-framework qtbase qtqc qttranslations ];

    nativeBuildInputs = [ cmake pkgconfig extra-cmake-modules ];

    meta = with stdenv.lib; {
      license     = licenses.lgpl2;
      homepage    = http://www.kde.org;
      maintainers = with maintainers; [ ttuegel peterhoeg ];
      platforms   = platforms.unix;
      inherit broken;
    };
  };

in {
  kirigami_1 = generic rec {
    name    = "${pname}-${version}";
    version = "1.1.0";
    sha256  = "1p9ydggwbyfdgwmvyc8004sk9mfshlg9b83lzvz9qk3a906ayxv6";
    qtqc    = qtquickcontrols;
    broken  = false;
  };

  kirigami_2 = generic rec {
    name    = "${pname}2-${version}";
    version = "2.1.0";
    sha256  = "0d79h10jzv9z7xzap4k9vbw6p9as8vdkz3x6xlzx407i9sbzyi77";
    qtqc    = qtquickcontrols2;
    broken  = builtins.compareVersions qtbase.version "5.7.0" < 0;
  };
}
