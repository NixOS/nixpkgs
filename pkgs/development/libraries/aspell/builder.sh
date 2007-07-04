source $stdenv/setup
genericBuild

# dictionaries search for aspell and prezip-bin
export PATH=$out/bin:$PATH
mkdir dict-tmp
cd dict-tmp
for d in $dictionaries; do
  tar jxvf $d
  cd aspell6-*
  ./configure
  make
  make install
  rm -rf aspell6-*
  cd ..
done
