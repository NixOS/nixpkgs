{ fetchPypi, stdenv, buildPythonPackage }:

buildPythonPackage rec {
  pname = "zc.buildout";
  version = "2.13.2";

  src = fetchPypi {
    inherit pname version;
    sha256 = "5dd4de86dda684c46ef8ee9cc84e335ca7f6275d4363a684de82225270d1e328";
  };

  patches = [ ./nix.patch ];

  postInstall = "mv $out/bin/buildout{,-nix}";

  meta = {
    homepage = http://www.buildout.org;
    description = "A software build and configuration system";
    license = stdenv.lib.licenses.zpl21;
    maintainers = [ stdenv.lib.maintainers.goibhniu ];
  };
}
