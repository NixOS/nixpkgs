{ lib, buildPythonPackage, fetchPypi }:

buildPythonPackage rec {
  pname = "buildbot-pkg";
  version = "2.4.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "0na336jwibgbix8fr4jki1gqys44kkm0a8q32llcr2z08igs4mvy";
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
