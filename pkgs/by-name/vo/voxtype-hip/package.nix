{
  voxtype,
}@args:

(voxtype.override ({ hipSupport = true; } // removeAttrs args [ "voxtype" ])).overrideAttrs (prev: {
  passthru = removeAttrs prev.passthru [ "update-script" ];
})
