{ mkDerivation, lib, fetchurl
, cmake
, qtbase
}:

let
  version = "1.9.0";
in

mkDerivation {
  pname = "kdsoap";
  inherit version;
  meta = {
    description = "A Qt-based client-side and server-side SOAP component";
    longDescription = ''
      KD Soap is a Qt-based client-side and server-side SOAP component.

      It can be used to create client applications for web services and also
      provides the means to create web services without the need for any further
      component such as a dedicated web server.
    '';
    license = with lib.licenses; [ gpl2 gpl3 lgpl21 ];
    maintainers = [ lib.maintainers.ttuegel ];
  };
  src = fetchurl {
    url = "https://github.com/KDAB/KDSoap/releases/download/kdsoap-${version}/kdsoap-${version}.tar.gz";
    sha256 = "0a28k48cmagqxhaayyrqnxsx1zbvw4f06dgs16kl33xhbinn5fg3";
  };
  outputs = [ "out" "dev" ];
  nativeBuildInputs = [ cmake ];
  buildInputs = [ qtbase ];
  postInstall = ''
    moveToOutput bin/kdwsdl2cpp "$dev"
    sed -i "$out/lib/cmake/KDSoap/KDSoapTargets.cmake" \
        -e "/^  INTERFACE_INCLUDE_DIRECTORIES/ c   INTERFACE_INCLUDE_DIRECTORIES \"$dev/include\""
    sed -i "$out/lib/cmake/KDSoap/KDSoapTargets-release.cmake" \
        -e "s@$out/bin@$dev/bin@"
  '';
}
