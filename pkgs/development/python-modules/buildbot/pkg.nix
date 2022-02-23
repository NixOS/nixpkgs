{ lib, buildPythonPackage, fetchPypi, isPy3k, buildbot }:

buildPythonPackage rec {
  pname = "buildbot-pkg";
  inherit (buildbot) version;

  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-A2a5rEL5MN9jlu5vVnUIKx9ma2H6wuJAWjkqLpQgcfc=";
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
    maintainers = with maintainers; [ ryansydnor lopsided98 ];
    license = licenses.gpl2;
  };
}
