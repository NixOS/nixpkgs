{ lib, buildPythonPackage, fetchPypi, isPy3k, buildbot }:

buildPythonPackage rec {
  pname = "buildbot-pkg";
  inherit (buildbot) version;

  src = fetchPypi {
    inherit pname version;
    sha256 = "1yz3k6dg15q4911x8kjy396dccfgrs50mjz278l09p6zmm71llax";
  };

  postPatch = ''
    # Their listdir function filters out `node_modules` folders.
    # Do we have to care about that with Nix...?
    substituteInPlace buildbot_pkg.py --replace "os.listdir = listdir" ""
  '';

  disabled = !isPy3k;

  meta = with lib; {
    homepage = "https://buildbot.net/";
    description = "Buildbot Packaging Helper";
    maintainers = with maintainers; [ nand0p ryansydnor lopsided98 ];
    license = licenses.gpl2;
  };
}
