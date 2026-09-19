{
  voxtype,
}@args:

(voxtype.override ({ onnxSupport = true; } // removeAttrs args [ "voxtype" ])).overrideAttrs
  (prev: {
    passthru = removeAttrs prev.passthru [ "update-script" ];
  })
