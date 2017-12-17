{ lib, buildPythonPackage, fetchPypi, setuptools }:

buildPythonPackage rec {
  pname = "buildbot-pkg";
  version = "1.4.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "06f4jvczbg9km0gfmcd1ljplf5w8za27i9ap9jnyqgh3j77smd7a";
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
