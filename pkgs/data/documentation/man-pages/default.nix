{ lib, stdenv, groff, fetchurl }:

stdenv.mkDerivation rec {
  pname = "man-pages";
  version = "6.05";

  src = fetchurl {
    url = "mirror://kernel/linux/docs/man-pages/${pname}-${version}.tar.xz";
    sha256 = "sha256-ibFEXP4uPei9E5dYx48Is3gTz/IXufscjfVf2UB4daY=";
  };

  buildInputs = [
    groff
  ];

  makeFlags = [ "prefix=$(out)" ];

  # Only build regular man pages
  # Don't build html or pdf for now
  buildFlags = [ "build-catman" ];

  # Append `.*` to share/lint/groff/man.ignore.grep to ignore troff errors
  preBuild = ''
    # troff warnings cause the build to fail
    # (see the `groff_man_ignore_grep` make variable and
    # the `_CATMAN_MAN_set` build target in share/mk/build/catman.mk)

    # Append .* to man.ignore.grep to effectively ignore groff errors
    echo ".*" >> share/lint/groff/man.ignore.grep
  '';

  postInstall = ''
    # conflict with shadow-utils
    rm $out/share/man/man5/passwd.5 \
       $out/share/man/man3/getspnam.3

    # The manpath executable looks up manpages from PATH. And this package won't
    # appear in PATH unless it has a /bin folder
    mkdir -p $out/bin
  '';
  outputDocdev = "out";

  meta = with lib; {
    description = "Linux development manual pages";
    homepage = "https://www.kernel.org/doc/man-pages/";
    license = licenses.gpl2Plus;
    platforms = with platforms; unix;
    priority = 30; # if a package comes with its own man page, prefer it
  };
}
