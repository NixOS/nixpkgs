{stdenv, fetchurl}:

stdenv.mkDerivation {
  name = "apr-1.3.3";
  
  src = fetchurl {
    url = mirror://apache/apr/apr-1.3.3.tar.bz2;
    sha256 = "0dyxw3km88f0li1d39vyr09670yb12xn8j1h8dq331kc6rw3npyr";
  };

  # For now, disable detection of epoll to ensure that Apache still
  # runs on Linux 2.4 kernels.  Once we've dropped support for 2.4 in
  # Nixpkgs, this can go.  In general, it's a problem that APR
  # detects characteristics of the build system's kernel to decide
  # what to use at runtime, since it's impure.
  #apr_cv_epoll = "no";

  meta = {
    homepage = http://apr.apache.org/;
    description = "The Apache Portable Runtime library";
  };
}
