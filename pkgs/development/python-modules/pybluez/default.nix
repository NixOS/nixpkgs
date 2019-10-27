{ stdenv
, buildPythonPackage
, fetchFromGitHub
, pkgs
}:

buildPythonPackage rec {
  version = "unstable-20160819";
  pname = "pybluez";

  propagatedBuildInputs = [ pkgs.bluez ];

  src = fetchFromGitHub {
    owner = "karulis";
    repo = pname;
    rev = "a0b226a61b166e170d48539778525b31e47a4731";
    sha256 = "104dm5ngfhqisv1aszdlr3szcav2g3bhsgzmg4qfs09b3i5zj047";
  };

  # the tests do not pass
  doCheck = false;

  meta = with stdenv.lib; {
    description = "Bluetooth Python extension module";
    license = licenses.gpl2;
    maintainers = with maintainers; [ leenaars ];
  };

}
