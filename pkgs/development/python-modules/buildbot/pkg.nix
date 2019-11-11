{ lib, buildPythonPackage, fetchPypi }:

buildPythonPackage rec {
  pname = "buildbot-pkg";
  version = "2.5.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "7c5b508c8c0d2fef5cdf4001c9f1e848f06fe8d6c30d8dff571a1a1fd251c9d7";
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
