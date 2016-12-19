{ stdenv, cmake, fetchzip }:

stdenv.mkDerivation rec {
  name = "gmock-${version}";
  version = "1.7.0";

  src = fetchzip {
    url = "https://googlemock.googlecode.com/files/gmock-${version}.zip";
    sha256 = "04n9p6pf3mrqsabrsncv32d3fqvd86zmcdq3gyni7liszgfk0paz";
  };

  buildInputs = [ cmake ];

  buildPhase = ''
    # avoid building gtest
    make gmock gmock_main
  '';

  installPhase = ''
    mkdir -p $out/lib
    cp -v libgmock.a libgmock_main.a $out/lib
    cp -v -r ../include $out
    cp -v -r ../src $out
  '';

  meta = {
    description = "Google mock: Google's framework for writing C++ mock classes";
    homepage = https://code.google.com/p/googlemock/;
    license = stdenv.lib.licenses.bsd3;
    maintainers = [ stdenv.lib.maintainers.auntie ];
    platforms = stdenv.lib.platforms.unix;
  };

  passthru = { source = src; };
}
