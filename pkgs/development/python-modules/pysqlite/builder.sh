source $stdenv/setup

configurePhase() {
	substituteInPlace "setup.cfg" \
		--replace "/usr/local/include" "$sqlite/include" \
		--replace "/usr/local/lib" "$sqlite/lib"
	cp setup.cfg /tmp
}

buildPhase() {
	$python/bin/python setup.py build
}

installPhase() {
	$python/bin/python setup.py install --prefix=$out
}

genericBuild
