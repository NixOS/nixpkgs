{stdenv, fetchurl, unzip}: 

assert stdenv.system == "i686-linux";

(stdenv.mkDerivation {
  name = "jre-1.5.0";
  version = "jre1.5.0_07";
  builder = ./builder.sh;
  src = fetchurl {
    url = http://jdl.sun.com/webapps/download/AutoDL?BundleId=10542;
    md5 = "e2ad1c9e47f3e34d1efae059b9e2a2d9";
  };
  buildInputs = [unzip];
})

// {mozillaPlugin = "/plugin/i386/ns7";}
