{ stdenv, fetchurl, perl
, enableStaticLibraries ? true
}:

stdenv.mkDerivation {
  name = "directfb-1.0.0-pre-rc2";
  src = fetchurl {
    url = http://directfb.org/downloads/Core/DirectFB-1.0.0-rc2.tar.gz;
    md5 = "1996c8e90075b1177b847cd594122401";
  };
  buildInputs = [perl];
  configureFlags = "${if enableStaticLibraries then "--enable-static" else ""}";
}
