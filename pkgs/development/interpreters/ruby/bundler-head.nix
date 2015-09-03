{ buildRubyGem, coreutils, fetchgit }:

buildRubyGem {
  name = "bundler-2015-01-11";
  src = fetchgit {
    url = "https://github.com/bundler/bundler.git";
    rev = "a2343c9eabf5403d8ffcbca4dea33d18a60fc157";
    sha256 = "1p7kzhmicfljy9n7nq3qh6lvrsckiq76ddypf6s55gfh1l98z4k9";
    leaveDotGit = true;
  };
  dontPatchShebangs = true;
  postInstall = ''
    find $out -type f -perm /0100 | while read f; do
      substituteInPlace $f \
         --replace "/usr/bin/env" "${coreutils}/bin/env"
    done
  '';
}
