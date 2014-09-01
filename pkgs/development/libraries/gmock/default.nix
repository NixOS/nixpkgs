{ stdenv, fetchurl, unzip, cmake}:

stdenv.mkDerivation rec {
  version = "1.7.0";
  name = "gmock-${version}";

  src = fetchurl {
    url = "https://googlemock.googlecode.com/files/${name}.zip";
    sha256="26fcbb5925b74ad5fc8c26b0495dfc96353f4d553492eb97e85a8a6d2f43095b";
  };

  buildInputs = [ unzip cmake ];

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
  };
}
