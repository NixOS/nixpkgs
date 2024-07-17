{
  runCommand,
  openjdk,
  nukeReferences,
}:

runCommand "${openjdk.name}-bootstrap.tar.xz" { } ''
  mkdir -pv openjdk-bootstrap/lib

  # Do a deep copy of the openjdk
  cp -vrL ${openjdk.home} openjdk-bootstrap/lib

  # Includes are needed for building the native jvm
  cp -vrL ${openjdk}/include openjdk-bootstrap

  # The binaries are actually stored in the openjdk lib
  ln -sv lib/openjdk/bin openjdk-bootstrap/bin
  find . -name libjli.so
  (cd openjdk-bootstrap/lib; find . -name libjli.so -exec ln -sfv {} libjli.so \;)

  chmod -R +w openjdk-bootstrap

  # Remove components we don't need
  find openjdk-bootstrap -name \*.diz -exec rm {} \;
  find openjdk-bootstrap -name \*.ttf -exec rm {} \;
  find openjdk-bootstrap -name \*.gif -exec rm {} \;
  find openjdk-bootstrap -name src.zip -exec rm {} \;
  rm -rf openjdk-bootstrap/lib/openjdk/jre/bin

  # Remove all of the references to the native nix store
  find openjdk-bootstrap -print0 | xargs -0 ${nukeReferences}/bin/nuke-refs

  # Create the output tarball
  tar cv openjdk-bootstrap | xz > $out
''
