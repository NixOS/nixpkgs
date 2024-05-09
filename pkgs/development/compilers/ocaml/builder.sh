if [ -e "$NIX_ATTRS_SH_FILE" ]; then . "$NIX_ATTRS_SH_FILE"; elif [ -f .attrs.sh ]; then . .attrs.sh; fi
source $stdenv/setup

configureFlags="-prefix $out $configureFlags"
genericBuild

#cd emacs/
#mkdir -p $out/share/ocaml/emacs
#make EMACSDIR=$out/share/ocaml/emacs install
