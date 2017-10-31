{ stdenv, fetchgit, flex, bison }:

stdenv.mkDerivation rec {
  name = "dtc-${version}";
  version = "1.4.4";

  src = fetchgit {
    url = "git://git.kernel.org/pub/scm/utils/dtc/dtc.git";
    rev = "refs/tags/v${version}";
    sha256 = "1pxp7700b3za7q4fnsnxx6i8v66rnr8p6lyi7jf684y1hq5ynlnf";
  };

  nativeBuildInputs = [ flex bison ];

  installFlags = [ "INSTALL=install" "PREFIX=$(out)" ];

  meta = with stdenv.lib; {
    description = "Device Tree Compiler";
    homepage = https://git.kernel.org/cgit/utils/dtc/dtc.git;
    license = licenses.gpl2; # dtc itself is GPLv2, libfdt is dual GPL/BSD
    maintainers = [ maintainers.dezgeg ];
    platforms = platforms.unix;
  };
}
