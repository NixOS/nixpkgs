{ lib
, buildPythonPackage
, fetchPypi
, debtcollector
, iso8601
, netaddr
, netifaces
, oslo-i18n
, packaging
, pbr
, pytz

, bandit
}:
let
  bandit_1_5_1 = bandit.overrideAttrs (old: {
    version = "1.5.1";
    name = "bandit-1.5.1";
    src = fetchPypi {
      pname = "bandit";
      version = "1.5.1";
      sha256 = "0k5sd4xgd6lp2ap1vd8nk5fabcdyw62cf9fmj791n7nyx77zl4wl";
    };
  });
in
buildPythonPackage rec {
  pname = "oslo-utils";
  version = "4.4.0";

  src = fetchPypi {
    pname = "oslo.utils";
    inherit version;
    sha256 = "1yw4jaqnqvmmxvvd9ifsywhy41gaf4lcimgla5ygbpniwfqf20qn";
  };

  patches = [ ./tox-pass-system-pythonpath.patch ];

  propagatedBuildInputs = [
    debtcollector
    iso8601
    netaddr
    netifaces
    oslo-i18n
    packaging
    pbr
    pytz
  ];

  checkInputs = [
    bandit_1_5_1
  ];

  # Circular dependencies on oslo-config, see https://bugs.launchpad.net/oslo.config/+bug/1893978
  doCheck = false;

  meta = with lib; {
    description = "Oslo Utility library";
    license = licenses.asl20;
    longDescription = ''
      The oslo.utils library provides support for common utility type
      functions, such as encoding, exception handling, string manipulation,
      and time handling.
    '';
    maintainers = with maintainers; [ shamilton ];
    platforms = platforms.linux;
  };
}
