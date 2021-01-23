{ lib, buildPythonPackage, fetchPypi, isPy3k, buildbot }:

buildPythonPackage rec {
  pname = "buildbot-pkg";
  inherit (buildbot) version;

  src = fetchPypi {
    inherit pname version;
    sha256 = "1wr8fxa80c6vq55zv7k9rf61r805flrhd2v28qfl05jz1inghysb";
  };

  postPatch = ''
    # Their listdir function filters out `node_modules` folders.
    # Do we have to care about that with Nix...?
    substituteInPlace buildbot_pkg.py --replace "os.listdir = listdir" ""
  '';

  # No tests
  doCheck = false;

  pythonImportsCheck = [ "buildbot_pkg" ];

  disabled = !isPy3k;

  meta = with lib; {
    homepage = "https://buildbot.net/";
    description = "Buildbot Packaging Helper";
    maintainers = with maintainers; [ nand0p ryansydnor lopsided98 ];
    license = licenses.gpl2;
  };
}
