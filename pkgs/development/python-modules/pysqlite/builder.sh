source $stdenv/setup

configurePhase() {
	substituteInPlace "setup.cfg" \
		--replace "/usr/local/include" "$sqlite/include" \
		--replace "/usr/local/lib" "$sqlite/lib"
	cp setup.cfg /tmp
}

buildPhase() {
	python setup.py build
}

installPhase() {
	python setup.py install --prefix=$out

	ensureDir "$out/doc"
	mv -v "$out/pysqlite2-doc" "$out/doc/$name"
}

genericBuild
