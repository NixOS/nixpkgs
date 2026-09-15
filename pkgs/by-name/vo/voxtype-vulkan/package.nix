{
  voxtype,
}@args:

(voxtype.override ({ vulkanSupport = true; } // removeAttrs args [ "voxtype" ])).overrideAttrs
  (prev: {
    passthru = removeAttrs prev.passthru [ "update-script" ];
  })
