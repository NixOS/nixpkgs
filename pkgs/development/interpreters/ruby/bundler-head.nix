{ buildRubyGem, coreutils, fetchgit }:

buildRubyGem {
  name = "bundler-2015-01-11";
  src = fetchgit {
    url = "https://github.com/bundler/bundler.git";
    rev = "a2343c9eabf5403d8ffcbca4dea33d18a60fc157";
    sha256 = "1vzm21fc37w89psxfk2fzi64zyb3gyhzr9smd6jk2r2kvgp6d38b";
    leaveDotGit = true;
  };
  dontPatchShebangs = true;
  postInstall = ''
    find $out -type f -perm +0100 | while read f; do
      substituteInPlace $f \
         --replace "/usr/bin/env" "${coreutils}/bin/env"
    done
  '';
}
