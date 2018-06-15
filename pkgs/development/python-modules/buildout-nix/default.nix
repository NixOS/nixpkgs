{ fetchurl, stdenv, buildPythonPackage }:

buildPythonPackage rec {
  pname = "zc.buildout";
  version = "2.11.4";
  name = "${pname}-nix-${version}";

  src = fetchurl {
    url = "mirror://pypi/${builtins.substring 0 1 pname}/${pname}/${pname}-${version}.tar.gz";
    sha256 = "20b22d9c99c99909b6b2dc679e8acd9e1fcf9f58e23f336d8b2c5be70617fbb2";
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
