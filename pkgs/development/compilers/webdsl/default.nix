{stdenv, fetchurl, pkgconfig, strategoPackages}:

stdenv.mkDerivation rec {
  name = "webdsl-8.8pre25482548";

  src = fetchurl {
    url = "http://releases.strategoxt.org/webdsl/${name}-chm695sm/webdsl-8.8pre2548.tar.gz";
    sha256 = "cc4bcc9ef98d35e96b9874d48e061c5bc18cb26300a031becc227a1cd5a1deac";
  };

  buildInputs = [
    pkgconfig strategoPackages.aterm strategoPackages.sdf
    strategoPackages.strategoxt strategoPackages.javafront
  ];

  meta = {
    homepage = http://webdsl.org/;
    description = "A domain-specific language for developing dynamic web applications with a rich data model";
  };
}
