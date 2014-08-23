{ stdenv, fetchurl, getopt, bash }:

stdenv.mkDerivation rec {
  name    = "libseccomp-${version}";
  version = "2.1.1";

  src = fetchurl {
    url    = "mirror://sourceforge/libseccomp/libseccomp-${version}.tar.gz";
    sha256 = "0744mjx5m3jl1hzz13zypivl88m0wn44mf5gsrd3yf3w80gc24l8";
  };

  # This fixes the check for 'getopt' to function appropriately.
  # Additionally, this package can optionally include the kernel
  # headers if they exist, or use its own inline copy of the source
  # for talking to the seccomp filter - we opt to always use the
  # inline copy
  patchPhase = ''
    substituteInPlace ./configure --replace "/bin/bash" "${bash}/bin/bash"
    substituteInPlace ./configure --replace "verify_deps getopt" ""
    substituteInPlace ./configure --replace getopt ${getopt}/bin/getopt
    substituteInPlace ./configure --replace 'opt_sysinc_seccomp="yes"' 'opt_sysinc_seccomp="no"'
  '';

  meta = {
    description = "high level library for the Linux Kernel seccomp filter";
    homepage    = "http://sourceforge.net/projects/libseccomp";
    license     = stdenv.lib.licenses.lgpl2;
    platforms   = stdenv.lib.platforms.linux;
    maintainers = [ stdenv.lib.maintainers.thoughtpolice ];
  };
}
