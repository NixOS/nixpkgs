{ buildRubyGem, makeWrapper, ruby, coreutils }:

buildRubyGem {
  name = "bundler-1.10.5";
  namePrefix = "";
  sha256 = "1zkxw6699bbmsamrij2lirscbh0j58p1p3bql22jsxvx34j6w5nc";
  dontPatchShebangs = true;
  postInstall = ''
    find $out -type f -perm /0100 | while read f; do
      substituteInPlace $f \
         --replace "/usr/bin/env" "${coreutils}/bin/env"
    done

    wrapProgram $out/bin/bundler \
      --prefix PATH ":" ${ruby}/bin
  '';
}
