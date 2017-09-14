{ stdenv, fetchurl, buildPythonPackage, pycurl, isPy3k }:

buildPythonPackage rec {
  pname = "koji";
  version = "1.8";
  name = "${pname}-${version}";
  format = "other";

  src = fetchurl {
    url = "https://github.com/koji-project/koji/archive/koji-1.8.0.tar.gz";
    sha256 = "17rkipdxccdccbbb70f9wx91cq9713psmq23j7lgb4mlnwan926h";
  };

  propagatedBuildInputs = [ pycurl ];

  # Judging from SyntaxError
  disabled = isPy3k;

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
