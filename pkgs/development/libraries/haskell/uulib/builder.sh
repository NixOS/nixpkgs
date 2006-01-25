source $stdenv/setup

#manual setup of ghc
PATH=$ghc/bin:$PATH

#unpack
tar xzf "$src" &&
cd uulib-* &&

#configure
ghc --make Setup.hs -o setup -package Cabal &&
./setup configure --prefix=$out &&

#make
./setup build &&

#install
./setup copy &&

#register package locally (might use wrapper instead of ugly sed)
echo '[]' > package.conf &&
./setup register --gen-script &&
sed "/ghc-pkg/ s|update -|-f package.conf update -|" register.sh > register-local.sh &&
sh register-local.sh &&
mv package.conf $out/ &&

#add dependencies
#dependencies contains a FSO per line
#for ghc     : prefix each FSO with -package-conf
#for ghc-pkg : prefix each FSO with -f or --package-conf (note the difference with ghc)
#both        : append with package.conf
#
#example: $(sort FSO1/dependencies FSO2/dependencies | uniq | sed 's|^|FSO/|; s|$|/package.conf|')

#no dependencies
touch $out/dependencies
