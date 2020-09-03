{ lib
, buildPythonPackage
, fetchPypi
, pbr
, six

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
  pname = "oslo-i18n";
  version = "5.0.0";

  src = fetchPypi {
    pname = "oslo.i18n";
    inherit version;
    sha256 = "11v8zkqk8v19b8jj8ij0xmz2dp2369jyc1zlz1qsqx1sqwzaww9f";
  };

  patches = [ ./tox-pass-system-pythonpath.patch ];

  propagatedBuildInputs = [
    pbr
    six
  ];
  checkInputs = [
    bandit_1_5_1
  ];

  # Circular dependencies on oslo-config, see https://bugs.launchpad.net/oslo.config/+bug/1893978
  doCheck = false;

  meta = with lib; {
    description = "Openstack internationalization and translation library";
    license = licenses.asl20;
    maintainers = with maintainers; [ shamilton ];
    platforms = platforms.linux;
  };
}
