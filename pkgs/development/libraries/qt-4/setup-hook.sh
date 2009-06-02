export QTDIR=@out@

if [ -z "$normalQt" ]; then
  # This helps for g++, but not for moc. And no qt4 package should expect
  # having all qt4 header files dirs into -I. But the KDE nix expressions want
  # this.
  for d in @out@/include/*; do
      export NIX_CFLAGS_COMPILE="$NIX_CFLAGS_COMPILE -I$d"
  done
fi
