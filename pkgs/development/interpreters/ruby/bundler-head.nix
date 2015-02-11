{ buildRubyGem, coreutils, fetchgit }:

buildRubyGem {
  name = "bundler-HEAD";
  src = fetchgit {
    url = "https://github.com/bundler/bundler.git";
    rev = "a2343c9eabf5403d8ffcbca4dea33d18a60fc157";
    sha256 = "1l4r55n1wzr817l225l6pm97li1mxg9icd8s51cpfihh91nkdz68";
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
