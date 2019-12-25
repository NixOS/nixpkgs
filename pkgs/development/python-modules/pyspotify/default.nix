{ stdenv
, buildPythonPackage
, fetchurl
, cffi
, pkgs
}:

buildPythonPackage rec {
  pname = "pyspotify";
  version = "2.1.2";

  src = fetchurl {
    url = "https://github.com/mopidy/pyspotify/archive/v${version}.tar.gz";
    sha256 = "0g3dvwpaz7pqrdx53kyzkh31arlmdzz1hb7jp8m488lbsf47w6nd";
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
