{ buildRubyGem, coreutils, fetchgit }:

buildRubyGem {
  name = "bundler-HEAD";
  src = fetchgit {
    url = "https://github.com/bundler/bundler.git";
    rev = "17919e790cd8f6fb369d6afc81f0afec6fb5ad8b";
    sha256 = "10gqashaax0i18gs95pijqsnpnwfj9v3va5rpxps0v597d16px9b";
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
