{ lib, buildPythonPackage, fetchPypi }:

buildPythonPackage rec {
  pname = "zc.buildout";
  version = "2.13.6";

  src = fetchPypi {
    inherit pname version;
    sha256 = "ac6edd48b1d7b1fba383dd0840fd49c53266f6bd426111a0195bcc640f4aff0f";
  };

  patches = [ ./nix.patch ];

  postInstall = "mv $out/bin/buildout{,-nix}";

  meta = with lib; {
    homepage = "http://www.buildout.org";
    description = "A software build and configuration system";
    license = licenses.zpl21;
    maintainers = [ maintainers.goibhniu ];
  };
}
