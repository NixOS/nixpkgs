. $stdenv/setup 

unzip $src

happy Language/Haskell/Harp/Parser.ly
ghc --make TrHarp.hs -o trharp


mkdir $out
mkdir $out/bin
cp trharp $out/bin/

ghc -c Language/Haskell/Harp/Match.hs

mkdir -p $out/hslibs/Language/Haskell/Harp/
cp Language/Haskell/Harp/Match.hs $out/hslibs/Language/Haskell/Harp/
cp Language/Haskell/Harp/Match.hi $out/hslibs/Language/Haskell/Harp/
cp Language/Haskell/Harp/Match.o $out/hslibs/Language/Haskell/Harp/
