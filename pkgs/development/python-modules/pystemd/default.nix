{ stdenv, lib, python, systemd }:

python.pkgs.buildPythonPackage rec {
  pname = "pystemd";
  version = "0.8.0";
  src = python.pkgs.fetchPypi {
    inherit pname version;
    sha256 = "0wlrid2xd73dmzl4m0jgg6cqmkx3qs9v9nikvwxd8a5b8chf9hna";
  };

  disabled = python.pythonOlder "3.4";

  buildInputs = [ systemd ];

  checkInputs = with python.pkgs; [ pytest mock ];
  checkPhase = "pytest tests";

  meta = with lib; {
    broken = (stdenv.isLinux && stdenv.isAarch64);
    description = "A thin Cython-based wrapper on top of libsystemd, focused on exposing the dbus API via sd-bus in an automated and easy to consume way.";
    homepage = "https://github.com/facebookincubator/pystemd/";
    license = licenses.lgpl21Plus;
    maintainers = with maintainers; [ flokli ];
  };
}
