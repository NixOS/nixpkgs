{ buildRubyGem, coreutils }:

buildRubyGem {
  name = "bundler-1.7.9";
  sha256 = "1gd201rh17xykab9pbqp0dkxfm7b9jri02llyvmrc0c5bz2vhycm";
  dontPatchShebangs = true;
  postInstall = ''
    find $out -type f -perm +0100 | while read f; do
      substituteInPlace $f \
         --replace "/usr/bin/env" "${coreutils}/bin/env"
    done
  '';
}
