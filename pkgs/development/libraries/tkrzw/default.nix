{ lib, stdenv, fetchurl, nimPackages }:

stdenv.mkDerivation rec {
  pname = "tkrzw";
  version = "1.0.26";
  # TODO: defeat multi-output reference cycles

  src = fetchurl {
    url = "https://dbmx.net/tkrzw/pkg/tkrzw-${version}.tar.gz";
    hash = "sha256-vbuzV4ZZnb0Vl+U9B8BorDD7mHQ7ILwkR35GaFs+aTI=";
  };

  postPatch = ''
    substituteInPlace configure \
      --replace 'PATH=".:/usr/local/bin:/usr/local/sbin:/usr/bin:/usr/sbin:/bin:/sbin:$PATH"' ""
  '';

  enableParallelBuilding = true;

  doCheck = false; # memory intensive

  passthru.tests.nim = nimPackages.tkrzw;
  meta = with lib; {
    description = "A set of implementations of DBM";
    homepage = "https://dbmx.net/tkrzw/";
    maintainers = with maintainers; [ ehmry ];
    license = licenses.asl20;
    platforms = platforms.all;
  };
}
