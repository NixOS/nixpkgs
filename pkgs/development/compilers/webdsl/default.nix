{ stdenv, fetchurl, pkgconfig, strategoPackages }:

stdenv.mkDerivation rec {
  name = "webdsl-9.7pre4168";

  src = fetchurl {
    url = "http://hydra.nixos.org/build/654196/download/1/${name}.tar.gz";
    sha256 = "08bec3ba02254ec7474ce70206b7be4390fe07456cfc57d927d96a21dd6dcb33";
  };

  buildInputs =
    [ pkgconfig strategoPackages.aterm strategoPackages.sdf
      strategoPackages.strategoxt strategoPackages.javafront
    ];

  # This corrected a failing build on at least one 64 bit Linux system.
  # See the comment about this here: http://webdsl.org/selectpage/Download/WebDSLOnLinux
  preBuild = (if stdenv.system == "x86_64-linux" then "ulimit -s unlimited" else "");

  meta = {
    homepage = http://webdsl.org/;
    description = "A domain-specific language for developing dynamic web applications with a rich data model";
  };
}
