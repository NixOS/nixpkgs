{ stdenv, fetchurl, buildPythonPackage, isPy3k, pycurl, six, rpm, dateutil }:

buildPythonPackage rec {
  pname = "koji";
  version = "1.14.3";
  format = "other";

  src = fetchurl {
    url = "https://releases.pagure.org/koji/${pname}-${version}.tar.bz2";
    sha256 = "0a3kn3qvspvx15imgzzzjsbvw6bqmbk29apbliqwifa9cj7pvb40";
  };

  propagatedBuildInputs = [ pycurl six rpm dateutil ];

  # Judging from SyntaxError
  disabled = isPy3k;

  makeFlags = [ "DESTDIR=$(out)" ];

  postInstall = ''
    mv $out/usr/* $out/
    cp -R $out/nix/store/*/* $out/
    rm -rf $out/nix
  '';

  meta = {
    description = "An RPM-based build system";
    homepage = https://pagure.io/koji;
    license = stdenv.lib.licenses.lgpl21;
    platforms = stdenv.lib.platforms.unix;
  };
}
