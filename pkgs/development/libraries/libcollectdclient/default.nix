{ stdenv, fetchurl, collectd }:
with stdenv.lib;

overrideDerivation collectd (oldAttrs: {
  name = "libcollectdclient-${collectd.version}";
  buildInputs = [ ];

  configureFlags = [
    "--without-daemon"
  ];

  makeFlags = [
    "-C src/libcollectdclient/"
  ];

}) // {
  meta = with stdenv.lib; {
    description = "C Library for collectd, a daemon which collects system performance statistics periodically";
    homepage = http://collectd.org;
    license = licenses.gpl2;
    platforms = platforms.linux; # TODO: collectd may be linux but the C client may be more portable?
    maintainers = [ maintainers.sheenobu maintainers.bjornfor ];
  };
}
