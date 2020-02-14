{ stdenv
, buildPythonPackage
, fetchurl
, cffi
, pkgs
}:

buildPythonPackage rec {
  pname = "pyspotify";
  version = "2.1.3";

  src = fetchurl {
    url = "https://github.com/mopidy/pyspotify/archive/v${version}.tar.gz";
    sha256 = "1y1zqkqi9jz5m9bb2z7wmax7g40c1snm3c6di6b63726qrf26rb7";
  };

  propagatedBuildInputs = [ cffi ];
  buildInputs = [ pkgs.libspotify ];

  # python zip complains about old timestamps
  preConfigure = ''
    find -print0 | xargs -0 touch
  '';

  postInstall = stdenv.lib.optionalString stdenv.isDarwin ''
    find "$out" -name _spotify.so -exec \
        install_name_tool -change \
        @loader_path/../Frameworks/libspotify.framework/libspotify \
        ${pkgs.libspotify}/lib/libspotify.dylib \
        {} \;
  '';

  # There are no tests
  doCheck = false;

  meta = with stdenv.lib; {
    homepage    = http://pyspotify.mopidy.com;
    description = "A Python interface to Spotify’s online music streaming service";
    license     = licenses.unfree;
    maintainers = with maintainers; [ lovek323 ];
    platforms   = platforms.unix;
  };

}
