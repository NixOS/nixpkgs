{ stdenv, fetchurl }:

stdenv.mkDerivation rec {
  version = "5.5.0";
  name = "libcollectdclient-${version}";
  tarname = "collectd-${version}";

  src = fetchurl {
    url = "http://collectd.org/files/${tarname}.tar.bz2";
    sha256 = "847684cf5c10de1dc34145078af3fcf6e0d168ba98c14f1343b1062a4b569e88";
  };

  configureFlags = [
    "--without-daemon"
  ];

  makeFlags = [
    "-C src/libcollectdclient/"
  ];

  NIX_CFLAGS_COMPILE = "-Wno-error=cpp";

  meta = with stdenv.lib; {
    description = "C Library for collectd, a daemon which collects system performance statistics periodically";
    homepage = http://collectd.org;
    license = licenses.gpl2;
    platforms = platforms.linux; # TODO: collectd may be linux but the C client may be more portable?
    maintainers = [ maintainers.sheenobu maintainers.bjornfor ];
  };
}
