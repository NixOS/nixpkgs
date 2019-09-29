{ lib, buildPythonPackage, fetchPypi }:

buildPythonPackage rec {
  pname = "buildbot-pkg";
  version = "2.4.1";

  src = fetchPypi {
    inherit pname version;
    sha256 = "0dfx3b6w9b326a0jrgc42a5ki84ya7bvx10pm62bfcby0mixhd4y";
  };

  postPatch = ''
    # Their listdir function filters out `node_modules` folders.
    # Do we have to care about that with Nix...?
    substituteInPlace buildbot_pkg.py --replace "os.listdir = listdir" ""
  '';

  meta = with lib; {
    homepage = http://buildbot.net/;
    description = "Buildbot Packaging Helper";
    maintainers = with maintainers; [ nand0p ryansydnor lopsided98 ];
    license = licenses.gpl2;
  };
}
