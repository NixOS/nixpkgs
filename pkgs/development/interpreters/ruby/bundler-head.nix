{ buildRubyGem, coreutils, fetchgitRecord, record-playback }:

buildRubyGem {
  name = "bundler-2015-01-11";
  src = fetchgitRecord {
    url = "https://github.com/bundler/bundler.git";
    rev = "a2343c9eabf5403d8ffcbca4dea33d18a60fc157";
    sha256 = "11s7mpx330lp1c640pq21rd60iz799838kjykf360lphq02y1d45";
    recordCommands = [ "ls-files -z" ];
  };
  buildInputs = [ record-playback ];
  dontPatchShebangs = true;
  postInstall = ''
    find $out -type f -perm -0100 | while read f; do
      substituteInPlace $f \
         --replace "/usr/bin/env" "${coreutils}/bin/env"
    done
  '';
}
