. $stdenv/setup

configureFlags="--with-aterm=$aterm --with-asf-library=$asflibrary --with-pt-support=$ptsupport --with-pgen=$pgen --with-sglr=$sglr"
genericBuild
