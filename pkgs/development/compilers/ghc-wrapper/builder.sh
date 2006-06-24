source $stdenv/setup

export HOME=$(pwd)/fake-home

makeWrapper() {
  wrapperBase="$1"
  wrapperName="$2"
  wrapper="$out/$wrapperName"
  shift; shift #the other arguments are passed to the source app
  echo '#!'"$SHELL" > "$wrapper"
  echo "exec \"$wrapperBase/$wrapperName\" $@" '"$@"' > "$wrapper"
  chmod +x "$wrapper"
}

mkdir -p $out/nix-support $out/bin
packages_db=$out/nix-support/package.conf

#create packages database (start with compiler base packages)
cp $ghc/lib/ghc-*/package.conf $packages_db
chmod +w $packages_db
for lib in $libraries; do
  sh $lib/nix-support/register.sh $packages_db || exit 1
done
rm -f $packages_db.old

#create the wrappers 
#NB: The double dash for ghc-pkg is not a typo!
makeWrapper $ghc "bin/ghc"         "-package-conf"  $packages_db
makeWrapper $ghc "bin/ghci"        "-package-conf"  $packages_db
makeWrapper $ghc "bin/runghc"      "-package-conf"  $packages_db
makeWrapper $ghc "bin/runhaskell"  "-package-conf"  $packages_db
makeWrapper $ghc "bin/ghc-pkg"     "--global-conf"  $packages_db

# todo: link all other binaries of ghc
