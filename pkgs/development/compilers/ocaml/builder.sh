if [ -e .attrs.sh ]; then source .attrs.sh; fi
source $stdenv/setup

configureFlags="-prefix $out $configureFlags"
genericBuild

#cd emacs/
#mkdir -p $out/share/ocaml/emacs
#make EMACSDIR=$out/share/ocaml/emacs install
