{ buildRubyGem, coreutils, fetchgit }:

buildRubyGem {
  name = "bundler-1.8.9";
  namePrefix = "";
  sha256 = "1k4sk4vf0mascqnahdnqymhr86dqj92bddciz5b2p9sv3qzryq57";
  dontPatchShebangs = true;
  postInstall = ''
    find $out -type f -perm -0100 | while read f; do
      substituteInPlace $f \
         --replace "/usr/bin/env" "${coreutils}/bin/env"
    done
  '';
}
