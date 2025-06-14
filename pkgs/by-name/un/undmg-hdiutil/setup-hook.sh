unpackCmdHooks+=(_tryUnpackDmg)
_tryUnpackDmg() {
  if ! [[ "$curSrc" =~ \.dmg$ ]]; then return 1; fi
  mnt=$(TMPDIR=/tmp mktemp -d -t nix-XXXXXXXXXX)
  /usr/bin/hdiutil attach -nobrowse -mountpoint $mnt "$curSrc"
  mkdir source
  cp -a $mnt/* source
  /usr/bin/hdiutil detach $mnt -force
  rm -rf $mnt
}
