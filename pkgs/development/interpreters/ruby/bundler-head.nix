{ buildRubyGem, coreutils, fetchFromGitHub }:

buildRubyGem {
  name = "bundler-HEAD";
  src = fetchFromGitHub {
    owner  = "bundler";
    repo   = "bundler";
    rev    = "a2343c9eabf5403d8ffcbca4dea33d18a60fc157";
    sha256 = "05275drvlrrlbync39qdw9nrsabb5yxcns7a7rk5c0ggsfc6hsnb";
  };
  dontPatchShebangs = true;
  postInstall = ''
    find $out -type f -perm +0100 | while read f; do
      substituteInPlace $f \
         --replace "/usr/bin/env" "${coreutils}/bin/env"
    done
  '';
}
