source $stdenv/setup

preConfigure() {
  mkdir cracklib-dicts/
  cp $dicts cracklib-dicts/
}

preConfigure=preConfigure

postInstall() {
  $out/sbin/cracklib-format cracklib-dicts/* | $out/sbin/cracklib-packer cracklib_dict
  cp cracklib_dict.* $out/lib
}

postInstall=postInstall

genericBuild
