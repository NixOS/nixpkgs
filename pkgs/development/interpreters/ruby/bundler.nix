{ buildRubyGem, makeWrapper, ruby, coreutils }:

buildRubyGem {
  name = "bundler-1.9.2";
  namePrefix = "";
  sha256 = "0ck9bnqg7miimggj1d6qlabrsa5h9yaw241fqn15cvqh915209zk";
  dontPatchShebangs = true;
  postInstall = ''
    find $out -type f -perm +0100 | while read f; do
      substituteInPlace $f \
         --replace "/usr/bin/env" "${coreutils}/bin/env"
    done

    wrapProgram $out/bin/bundler \
      --prefix PATH ":" ${ruby}/bin
  '';
}
