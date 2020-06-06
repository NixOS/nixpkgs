{ lib, buildPythonPackage, fetchPypi, isPy3k }:

buildPythonPackage rec {
  pname = "buildbot-pkg";
  version = "2.8.1";

  src = fetchPypi {
    inherit pname version;
    sha256 = "03ppmrnpyd77azylv1c673cffk6x53j9flx4i99k33bljmdy8iv4";
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
