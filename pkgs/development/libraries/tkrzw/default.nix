{
  lib,
  stdenv,
  fetchurl,
}:

stdenv.mkDerivation rec {
  pname = "tkrzw";
  version = "1.0.31";
  # TODO: defeat multi-output reference cycles

  src = fetchurl {
    url = "https://dbmx.net/tkrzw/pkg/tkrzw-${version}.tar.gz";
    hash = "sha256-7FdHglIBTHGKRt66WNTGEe5qUcrIyTYPrnuVrUc8l08=";
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
    maintainers = with maintainers; [ ehmry ];
    license = licenses.asl20;
    platforms = platforms.all;
  };
}
