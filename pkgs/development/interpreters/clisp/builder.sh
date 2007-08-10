source $stdenv/setup || exit 1

set -e

tar jxvf $src
cd clisp-*
sed -e 's@/bin/pwd@'${coreutils}'&@' -i src/clisp-link.in
./configure --with-readline builddir --build \
	--prefix=$out --with-dynamic-ffi \
	--with-module=clx/new-clx --with-module=i18n \
	--with-module=bindings/glibc \
	--with-module=pcre --with-module=rawsock \
	--with-module=readline --with-module=syscalls \
	--with-module=wildcard --with-modules=zlib ||
	for i in $(find . -name config.log ); do
		echo -------
		echo $i;
		echo ===
		cat $i;
	done > /tmp/clisp-config-log
cd builddir
make install
