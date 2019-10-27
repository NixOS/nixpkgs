{ stdenv, fetchurl, buildPythonPackage, pycurl, six, rpm, dateutil }:

buildPythonPackage rec {
  pname = "koji";
  version = "1.13.0";
  format = "other";

  src = fetchurl {
    url = "https://releases.pagure.org/koji/${pname}-${version}.tar.bz2";
    sha256 = "18b18rcbdqqw33g7h20hf5bpbci2ixdi05yda1fvpv30c1kkzd8w";
  };

  propagatedBuildInputs = [ pycurl six rpm dateutil ];

  # Judging from SyntaxError
  #disabled = isPy3k;

  makeFlags = "DESTDIR=$(out)";

  postInstall = ''
    mv $out/usr/* $out/
    cp -R $out/nix/store/*/* $out/
    rm -rf $out/nix
  '';

  meta = {
    maintainers = [ ];
    platforms = stdenv.lib.platforms.unix;
  };
}
