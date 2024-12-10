{
  buildOctavePackage,
  stdenv,
  lib,
  fetchurl,
  pkg-config,
  pcre2,
}:

buildOctavePackage rec {
  pname = "strings";
  version = "1.3.1";

  src = fetchurl {
    url = "mirror://sourceforge/octave/${pname}-${version}.tar.gz";
    sha256 = "sha256-9l5eYgzw5K85trRAJW9eMYZxvf0RDNxDlD0MtwrSCLc=";
  };

  nativeBuildInputs = [
    pkg-config
  ];

  buildInputs = [
    pcre2
  ];

  # The gripes library no longer exists.
  # https://build.opensuse.org/package/view_file/openSUSE:Backports:SLE-15-SP3/octave-forge-strings/octave-forge-strings.spec
  # toascii is a deprecated function. Has been fixed in recent commits, but has
  # not been released yet.
  # https://sourceforge.net/p/octave/strings/ci/2db1dbb75557eef94605cb4ac682783ab78ac8d8/
  patchPhase = ''
    sed -i -s -e 's/gripes.h/errwarn.h/' -e 's/gripe_/err_/g' src/*.cc
    sed -i s/toascii/double/g inst/*.m
  '';

  meta = with lib; {
    homepage = "https://octave.sourceforge.io/strings/index.html";
    license = licenses.gpl3Plus;
    # Claims to have a freebsd license, but I found none.
    maintainers = with maintainers; [ KarlJoad ];
    description = "Additional functions for manipulation and analysis of strings";
    # Some pcre symbols claimed to be missing
    broken = stdenv.isDarwin;
  };
}
