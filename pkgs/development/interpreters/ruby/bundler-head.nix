{ buildRubyGem, coreutils, fetchgit }:

buildRubyGem {
  name = "bundler-2015-01-11";
  src = fetchgit {
    url = "https://github.com/bundler/bundler.git";
    rev = "a2343c9eabf5403d8ffcbca4dea33d18a60fc157";
    sha256 = "0l3jxk77jaf757kcbbmz0m3pdf0mx5p2zlbj5scxslhdv456422d";
    leaveDotGit = true;
  };
  dontPatchShebangs = true;
  postInstall = ''
    find $out -type f -perm -0100 | while read f; do
      substituteInPlace $f \
         --replace "/usr/bin/env" "${coreutils}/bin/env"
    done
  '';
}
