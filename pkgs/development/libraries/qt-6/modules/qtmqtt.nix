{ qtModule
, fetchurl
, qtbase
}:

qtModule rec {
  pname = "qtmqtt";
  version = "6.5.0";
  src = fetchurl {
    url = "https://github.com/qt/qtmqtt/archive/refs/tags/v${version}.tar.gz";
    sha256 = "qv3GYApd4QKk/Oubx48VhG/Dbl/rvq5ua0UinPlDDNY=";
  };
  qtInputs = [ qtbase ];
}
