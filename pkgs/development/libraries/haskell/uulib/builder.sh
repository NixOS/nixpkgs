source $stdenv/setup


export HOME=$(pwd)/fake-home


#add ghc to search path
test -n "$ghc" && PATH=$PATH:$ghc/bin

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

# Create package database. If we can find the ghc version we might install the
# package, like ghc does, in $out/lib/ghc-version/package.conf.

support=$out/nix-support &&
packages_db=$out/nix-support/package.conf &&

mkdir $support &&
cp $ghc/lib/ghc-*/package.conf $packages_db &&
chmod +w $packages_db &&
#echo '[]' > $packages_db &&

# We save a modified version of a register script. This gives a dependency on
# ghc, but this should not be a problem as long as $out is a static library.

./setup register --gen-script &&
sed '/ghc-pkg/ s|update -|-f "$1" update -|' register.sh > register-pkg.sh &&
sed '/ghc-pkg/ s|--auto-ghci-libs||' register-pkg.sh > $support/register.sh &&

# The package and its direct cabal dependencies are registered. This may result
# in duplicate registrations attempts but hopefully that will not result in
# errors.

# uulib has no dependencies on other ghc libraries
for dep in ; do
	sh $dep/nix-support/register.sh $packages_db || exit 1
done &&
sh register-pkg.sh $packages_db &&
rm -f $package_db.old
