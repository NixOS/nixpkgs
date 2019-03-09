{ lib, buildPythonPackage, fetchPypi, setuptools }:

buildPythonPackage rec {
  pname = "buildbot-pkg";
  version = "1.8.1";

  src = fetchPypi {
    inherit pname version;
    sha256 = "16gjdzkris6475bvsgvb0v6rkn4xb6f55s468q37n0l1r6n8snc3";
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
