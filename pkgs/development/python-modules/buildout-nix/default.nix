{ fetchPypi, stdenv, buildPythonPackage }:

buildPythonPackage rec {
  pname = "zc.buildout";
  version = "2.13.3";

  src = fetchPypi {
    inherit pname version;
    sha256 = "1dyc5g3yv7wm3hf3fcsh6y1wivzjj1bspafr5qqb653z9a31lsfn";
  };

  patches = [ ./nix.patch ];

  postInstall = "mv $out/bin/buildout{,-nix}";

  meta = {
    homepage = "http://www.buildout.org";
    description = "A software build and configuration system";
    license = stdenv.lib.licenses.zpl21;
    maintainers = [ stdenv.lib.maintainers.goibhniu ];
  };
}
