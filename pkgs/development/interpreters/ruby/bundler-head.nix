{ buildRubyGem, coreutils, fetchgit }:

buildRubyGem {
  name = "bundler-HEAD";
  src = fetchgit {
    url = "https://github.com/bundler/bundler.git";
    rev = "a2343c9eabf5403d8ffcbca4dea33d18a60fc157";
    sha256 = "0q7cjmz1fsrw3yfsr3h274qjamwnw01xgaqq3h5cjbqlrni4iq7k";
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
