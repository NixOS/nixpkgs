buildinputs="$aterm $sdf $strategoxt"
. $stdenv/setup || exit 1

tar zxf $src || exit 1
cd tiger-* || exit 1
./configure --prefix=$out \
	--with-aterm=$aterm \
	--with-sdf=$sdf \
	--with-stratego-xt=$strategoxt \
        --enable-tiger \
        --enable-ir \
	--enable-asm \
    || exit 1
make || exit 1
make install || exit 1
