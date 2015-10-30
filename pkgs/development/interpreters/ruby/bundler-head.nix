{ buildRubyGem, coreutils, fetchgit }:

buildRubyGem {
  name = "bundler-2015-01-11";
  src = fetchgit {
    url = "https://github.com/bundler/bundler.git";
    rev = "a2343c9eabf5403d8ffcbca4dea33d18a60fc157";
    sha256 = "06qsai4ac3i2xlr7nbc4anh4cy6jd9jjf3rpj254g9gwshqv0qgr";
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
