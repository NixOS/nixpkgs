{ lib, fetchurl, buildPythonPackage, isPy3k, pycurl, six, rpm, python-dateutil }:

buildPythonPackage rec {
  pname = "koji";
  version = "1.14.3";
  format = "other";

  src = fetchurl {
    url = "https://releases.pagure.org/koji/${pname}-${version}.tar.bz2";
    sha256 = "0a3kn3qvspvx15imgzzzjsbvw6bqmbk29apbliqwifa9cj7pvb40";
  };

  propagatedBuildInputs = [ pycurl six rpm python-dateutil ];

  # Judging from SyntaxError
  disabled = isPy3k;

  makeFlags = [ "DESTDIR=$(out)" ];

  postInstall = ''
    mv $out/usr/* $out/
    cp -R $out/nix/store/*/* $out/
    rm -rf $out/nix
  '';

  meta = with lib; {
    description = "An RPM-based build system";
    homepage = "https://pagure.io/koji";
    license = licenses.lgpl21;
    platforms = platforms.unix;
  };
}
