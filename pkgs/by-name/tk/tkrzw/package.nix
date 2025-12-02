{
  lib,
  stdenv,
  fetchurl,
}:

stdenv.mkDerivation rec {
  pname = "tkrzw";
  version = "1.0.32";
  # TODO: defeat multi-output reference cycles

  src = fetchurl {
    url = "https://dbmx.net/tkrzw/pkg/tkrzw-${version}.tar.gz";
    hash = "sha256-00BN+saJhjK2l4DA8JlMX2upYhkaYcmw9LU7qLsncxw=";
  };

  postPatch = ''
    substituteInPlace configure \
      --replace 'PATH=".:/usr/local/bin:/usr/local/sbin:/usr/bin:/usr/sbin:/bin:/sbin:$PATH"' ""
  '';

  enableParallelBuilding = true;

  doCheck = false; # memory intensive

  meta = with lib; {
    description = "Set of implementations of DBM";
    homepage = "https://dbmx.net/tkrzw/";
    license = licenses.asl20;
    platforms = platforms.all;
  };
}
