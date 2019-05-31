{ stdenv, python, systemd }:

python.pkgs.buildPythonPackage rec {
  pname = "pystemd";
  version = "0.6.0";
  src = python.pkgs.fetchPypi {
    inherit pname version;
    sha256 = "054a3ni71paqa1xa786840z3kjixcgyqdbscyq8nfxp3hwn0gz5i";
  };

  disabled = !python.pkgs.isPy3k;

  buildInputs = [ systemd ];

  checkInputs = with python.pkgs; [ pytest mock ];
  checkPhase = "pytest tests";

  meta = with stdenv.lib; {
    description = "A thin Cython-based wrapper on top of libsystemd, focused on exposing the dbus API via sd-bus in an automated and easy to consume way.";
    homepage = https://github.com/facebookincubator/pystemd/;
    license = licenses.lgpl21Plus;
    maintainers = with maintainers; [ flokli ];
  };
}
