{ lib
, buildPythonPackage
, fetchPypi
, msgpack
, oslo-utils
, pbr
, pytz

, bandit
, coverage
}:

buildPythonPackage rec {
  pname = "oslo-serialization";
  version = "4.0.0";

  src = fetchPypi {
    pname = "oslo.serialization";
    inherit version;
    sha256 = "0q58am92m53ax4mszsb00xdmxbmnynawhvp8ncn2hr753cbxyrgl";
  };

  patches = [ ./tox-pass-system-pythonpath.patch ];

  propagatedBuildInputs = [
    msgpack
    oslo-utils
    pbr
    pytz
  ];

  # Circular dependencies on oslotest, see https://bugs.launchpad.net/oslo.config/+bug/1893978
  checkInputs = [
    bandit
    coverage
  ];

  # Needs internet connection
  doCheck = false;

  meta = with lib; {
    description = "Oslo Serialization library";
    license = licenses.asl20;
    maintainers = with maintainers; [ shamilton ];
    platforms = platforms.linux;
  };
}
