{ fetchzip, lib }:

let
  version = "20170925";
in
fetchzip {
  name = "nanum-${version}";
  url = "mirror://ubuntu/pool/universe/f/fonts-nanum/fonts-nanum_${version}.orig.tar.xz";
  sha256 = "sha256-lSTeQEuMmlQxiQqrx9tNScifE8nMOUDJF3lCfoAFIJk=";

  postFetch = ''
    unpackDir="$TMPDIR/unpack"
    mkdir "$unpackDir"
    cd "$unpackDir"
    tar xf "$downloadedFile" --strip-components=1
    mkdir -p $out/share/fonts
    cp *.ttf $out/share/fonts
  '';

  meta = with lib; {
    description = "Nanum Korean font set";
    homepage = "https://hangeul.naver.com/font";
    license = licenses.ofl;
    maintainers = with lib.maintainers; [ serge ];
    platforms = platforms.all;
  };
}
