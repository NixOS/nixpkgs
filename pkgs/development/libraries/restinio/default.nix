{ lib, fetchzip }:

let
  pname = "restinio";
  version = "0.6.14";
in
fetchzip {
  name = "${pname}-${version}";
  url = "https://github.com/Stiffstream/restinio/releases/download/v.${version}/${pname}-${version}-full.tar.bz2";
  sha256 = "sha256-v/t3Lo1D6rHMx3GywPpEhOnHrT7JVC8n++YxpMTRfDM=";

  postFetch = ''
    mkdir -p $out/include/restinio
    tar -xjf $downloadedFile --strip-components=3 -C $out/include/restinio --wildcards "*/dev/restinio"
  '';

  meta = with lib; {
    description = "Cross-platform, efficient, customizable, and robust asynchronous HTTP/WebSocket server C++14 library";
    homepage = "https://github.com/Stiffstream/restinio";
    license = licenses.bsd3;
    platforms = platforms.all;
  };
}
