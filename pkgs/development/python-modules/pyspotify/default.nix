{ stdenv
, buildPythonPackage
, fetchurl
, cffi
, pkgs
}:

buildPythonPackage rec {
  pname = "pyspotify";
  version = "2.0.5";

  src = fetchurl {
    url = "https://github.com/mopidy/pyspotify/archive/v${version}.tar.gz";
    sha256 = "1ilbz2w1gw3f1bpapfa09p84dwh08bf7qcrkmd3aj0psz57p2rls";
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
    maintainers = with maintainers; [ lovek323 rickynils ];
    platforms   = platforms.unix;
  };

}
