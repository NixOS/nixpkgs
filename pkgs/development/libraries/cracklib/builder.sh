source $stdenv/setup

preConfigure() {
  mkdir cracklib-dicts/
  cp $dicts cracklib-dicts/
}

preConfigure=preConfigure

postInstall() {
  ./util/cracklib-format cracklib-dicts/* | ./util/cracklib-packer cracklib_dict
  cp cracklib_dict.* $out/lib
}

postInstall=postInstall

genericBuild
