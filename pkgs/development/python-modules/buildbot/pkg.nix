{ lib, buildPythonPackage, fetchPypi }:

buildPythonPackage rec {
  pname = "buildbot-pkg";
  version = "2.3.1";

  src = fetchPypi {
    inherit pname version;
    sha256 = "0bpqiih15b5kzx1r542m8j7ydbnmgzhdnkaxv0z7gjv21k78m5i5";
  };

  postPatch = ''
    # Their listdir function filters out `node_modules` folders.
    # Do we have to care about that with Nix...?
    substituteInPlace buildbot_pkg.py --replace "os.listdir = listdir" ""
  '';

  meta = with lib; {
    homepage = http://buildbot.net/;
    description = "Buildbot Packaging Helper";
    maintainers = with maintainers; [ nand0p ryansydnor ];
    license = licenses.gpl2;
  };
}
