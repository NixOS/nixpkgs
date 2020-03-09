{ lib, buildPythonPackage, fetchPypi, isPy3k }:

buildPythonPackage rec {
  pname = "buildbot-pkg";
  version = "2.7.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "03zb09r8w8dvd9qas7h6gdwlqc7q482ikph6h3708lpnkn72xdkb";
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
