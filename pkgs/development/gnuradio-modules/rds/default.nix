{ lib
, mkDerivation
, fetchFromGitHub
, gnuradio
, cmake
, pkg-config
, swig
, python
, log4cpp
, mpir
, thrift
, boost
, gmp
, icu
}:

let
  version = {
    "3.7" = "1.1.0";
    "3.8" = "3.8.0";
    "3.9" = null;
  }.${gnuradio.versionAttr.major};
  src = fetchFromGitHub {
    owner = "bastibl";
    repo = "gr-rds";
    rev = "v${version}";
    sha256 = {
      "3.7" = "0jkzchvw0ivcxsjhi1h0mf7k13araxf5m4wi5v9xdgqxvipjzqfy";
      "3.8" = "+yKLJu2bo7I2jkAiOdjvdhZwxFz9NFgTmzcLthH9Y5o=";
      "3.9" = null;
    }.${gnuradio.versionAttr.major};
  };
in mkDerivation {
  pname = "gr-rds";
  inherit version src;
  disabledForGRafter = "3.9";

  buildInputs = [
    log4cpp
    mpir
    boost
    gmp
    icu
  ] ++ lib.optionals (gnuradio.hasFeature "gr-ctrlport") [
    thrift
    python.pkgs.thrift
  ];

  nativeBuildInputs = [
    cmake
    pkg-config
    swig
    python
  ];

  meta = with lib; {
    description = "Gnuradio block for radio data system";
    homepage = "https://github.com/bastibl/gr-rds";
    license = licenses.gpl2Plus;
    platforms = platforms.unix;
    maintainers = with maintainers; [ mog ];
  };
}
