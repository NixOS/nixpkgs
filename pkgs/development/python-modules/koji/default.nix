{ stdenv, fetchurl, buildPythonPackage, pycurl }:

buildPythonPackage rec {
  pname = "koji";
  version = "1.8";
  name = "${pname}-${version}";
  format = "other";

  src = fetchurl {
    url = "https://fedorahosted.org/released/koji/koji-1.8.0.tar.bz2";
    sha256 = "10dph209h4jgajb5jmbjhqy4z4hd22i7s2d93vm3ikdf01i8iwf1";
  };

  propagatedBuildInputs = [ pycurl ];

  makeFlags = "DESTDIR=$(out)";

  postInstall = ''
    mv $out/usr/* $out/
    cp -R $out/nix/store/*/* $out/
    rm -rf $out/nix
  '';

  meta = {
    maintainers = [ stdenv.lib.maintainers.mornfall ];
    platforms = stdenv.lib.platforms.linux;
  };
}
