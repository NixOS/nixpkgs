. $stdenv/setup


configureFlags="-prefix $out $configureFlags"
genericBuild

#  make world
#  make bootstrap
#  make opt
#  make opt.opt
#  make install
#cd emacs/
#make EMACSDIR=$out/share/ocaml/emacs
