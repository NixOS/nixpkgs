source $stdenv/setup

configureFlags="--with-aterm=$aterm --with-sdf=$sdf --with-strategoxt=$strategoxt"
genericBuild
