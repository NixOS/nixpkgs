args: with args;

stdenv.mkDerivation {
  inherit suffix name ghc ;

  buildInputs = libraries ++ [ghcPkgUtil];

  phases="installPhase";

  installPhase="
    ensureDir \$out/bin
    if test -n \"\$ghcPackagedLibs\"; then
       g=:\$(echo \$ghc/lib/ghc-*/package.conf)
    fi

    for a in ghc ghci ghc-pkg; do
      app=$(ls -al $ghc/bin/$a | sed -n 's%.*-> \\(.*\\)%\\1%p');
cat > \"\$out/bin/\$a$suffix\" << EOF
#!`type -f sh | gawk '{ print $3; }'`
GHC_PACKAGE_PATH=\${GHC_PACKAGE_PATH}\${g} \$ghc/bin/$app \"\\\$@\"
EOF
      chmod +x \"\$out/bin/\$a$suffix\"
    done
";
}
