{ kwin, fetchpatch }:

let
  pname = "kwin-lowlatency";
  version = "5.20.5";
in kwin.overrideAttrs (o: {
  name = "${pname}-${version}";

  patches = (o.patches or [ ]) ++ [
    (fetchpatch {
      url = "https://tildearrow.org/storage/kwin-lowlatency/kwin-lowlatency-${version}.patch";
      sha256 = "14lzv38kkypqjwgdcd8f7lm7366y7cj08l3lh8qq1b49pza0zb2w";
    })
  ];
})
