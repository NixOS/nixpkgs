{ lib
, stdenv
, buildPythonPackage
, fetchFromGitHub
, cffi
, libspotify
}:

buildPythonPackage rec {
  pname = "pyspotify";
  version = "2.1.3";

  src = fetchFromGitHub {
    owner = "mopidy";
    repo = "pyspotify";
    rev = "v${version}";
    sha256 = "sha256-CjIRwSlR5HPOJ9tp7lrdcDPiKH3p/PxvEJ8sqVD5s3Q=";
  };

  propagatedBuildInputs = [ cffi ];
  buildInputs = [ libspotify ];

  # python zip complains about old timestamps
  preConfigure = ''
    find -print0 | xargs -0 touch
  '';

  postInstall = lib.optionalString stdenv.isDarwin ''
    find "$out" -name _spotify.so -exec \
        install_name_tool -change \
        @loader_path/../Frameworks/libspotify.framework/libspotify \
        ${libspotify}/lib/libspotify.dylib \
        {} \;
  '';

  # There are no tests
  doCheck = false;

  meta = with lib; {
    homepage = "http://pyspotify.mopidy.com";
    description = "A Python interface to Spotify’s online music streaming service";
    license = licenses.unfree;
    maintainers = with maintainers; [ lovek323 ];
  };
}
