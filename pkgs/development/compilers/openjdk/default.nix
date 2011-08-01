{stdenv, fetchurl, unzip, procps, coreutils}:

stdenv.mkDerivation {
  name = "openjdk-7b127";

  src = fetchurl {
    url = http://www.java.net/download/openjdk/jdk7/promoted/b147/openjdk-7-fcs-src-b147-27_jun_2011.zip;
    sha256 = "1qhwlz9y5qmwmja4qnxg6sn3pgsg1i11fb9j41w8l26acyhk34rs";
  };

  buildInputs = [ unzip procps ];

  postUnpack = ''
    substituteInPlace openjdk/jdk/make/common/shared/Defs-utils.gmk \
       --replace /bin/echo ${coreutils}/bin/echo
    substituteInPlace openjdk/jdk/make/common/shared/Defs-utils.gmk \
       --replace /usr/nix/store /nix/store
  '';
}
