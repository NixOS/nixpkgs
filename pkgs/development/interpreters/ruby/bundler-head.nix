{ buildRubyGem, coreutils, fetchgit }:

buildRubyGem {
  name = "bundler-HEAD";
  src = fetchgit {
    url = "https://github.com/bundler/bundler.git";
    rev = "a2343c9eabf5403d8ffcbca4dea33d18a60fc157";
    sha256 = "1f0isjrn4rwak3q6sbs6v6gqhwln32gv2dbd98r902nkg9i7y5i0";
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
