{stdenv, fetchurl}:

stdenv.mkDerivation {
  name = "libdaemon-0.12";
  src = fetchurl {
    url = http://0pointer.de/lennart/projects/libdaemon/libdaemon-0.12.tar.gz;
    sha256 = "1l1nhgc3m67bhpyyvrr48wz06h40ck6abhbns08g66jdckwckrrr";
  };
  configureFlags = "--disable-lynx";
}
