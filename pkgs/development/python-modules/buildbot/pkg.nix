{ lib, buildPythonPackage, fetchPypi, isPy3k }:

buildPythonPackage rec {
  pname = "buildbot-pkg";
  version = "2.8.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "09sf36h8q8wrp0n57nb9915k86qdjyjj4xpdzy8q4s9z121iw0xz";
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
