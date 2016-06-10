{ stdenv, fetchgit, flex, bison }:

stdenv.mkDerivation rec {
  name = "dtc-${version}";
  version = "1.4.1";

  src = fetchgit {
    url = "git://git.kernel.org/pub/scm/utils/dtc/dtc.git";
    rev = "refs/tags/v${version}";
    sha256 = "0wcn9x2vynwlfxk5c6jrf8lz7qvm1sbb9gh27drk1mx8msdh5hd5";
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
