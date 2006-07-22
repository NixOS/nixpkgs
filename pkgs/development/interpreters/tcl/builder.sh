source $stdenv/setup

preConfigure() {
  cd unix
}

preConfigure=preConfigure

postInstall() {
        make install-private-headers
	ln -s $out/bin/tclsh8.4 $out/bin/tclsh
}

postInstall=postInstall

genericBuild
