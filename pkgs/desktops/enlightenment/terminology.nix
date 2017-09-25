{ stdenv, fetchurl, pkgconfig, efl, pcre, curl, makeWrapper }:

stdenv.mkDerivation rec {
  name = "terminology-${version}";
  version = "1.1.1";

  src = fetchurl {
    url = "http://download.enlightenment.org/rel/apps/terminology/${name}.tar.xz";
    sha256 = "05ncxvzb9rzkyjvd95hzn8lswqdwr8cix6rd54nqn9559jibh4ns";
  };

  nativeBuildInputs = [
    (pkgconfig.override { vanilla = true; })
    makeWrapper
  ];

  buildInputs = [
    efl
    pcre
    curl
  ];

  postInstall = ''
    for f in $out/bin/*; do
      wrapProgram $f --prefix LD_LIBRARY_PATH : ${curl.out}/lib
    done
  '';

  meta = {
    description = "The best terminal emulator written with the EFL";
    homepage = http://enlightenment.org/;
    platforms = stdenv.lib.platforms.linux;
    license = stdenv.lib.licenses.bsd2;
    maintainers = with stdenv.lib.maintainers; [ matejc tstrobel ftrvxmtrx ];
  };
}
