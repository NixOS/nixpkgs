{ buildRubyGem, makeWrapper, ruby, coreutils }:

buildRubyGem {
  name = "bundler-1.10.6";
  namePrefix = "";
  sha256 = "1vlzfq0bkkj4jyq6av0y55mh5nj5n0f3mfbmmifwgkh44g8k6agv";
  dontPatchShebangs = true;
  postInstall = ''
    find $out -type f -perm -0100 | while read f; do
      substituteInPlace $f \
         --replace "/usr/bin/env" "${coreutils}/bin/env"
    done

    wrapProgram $out/bin/bundler \
      --prefix PATH ":" ${ruby}/bin
  '';
}
