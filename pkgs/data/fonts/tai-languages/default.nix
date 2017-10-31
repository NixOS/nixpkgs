{ lib, fetchzip }:

{
tai-ahom = fetchzip {
  name = "tai-ahom-2015-07-06";

  url = "https://github.com/enabling-languages/tai-languages/blob/b57a3ea4589af69bb8e87c6c4bb7cd367b52f0b7/ahom/.fonts/ttf/.original/AhomUnicode_FromMartin.ttf?raw=true";

  postFetch = "install -Dm644 $downloadedFile $out/share/fonts/truetype/AhomUnicode.ttf";

  sha256 = "03h8ql9d5bzq4j521j0cz08ddf717bzim1nszh2aar6kn0xqnp9q";

  meta = with lib; {
    homepage = https://github.com/enabling-languages/tai-languages;
    description = "Unicode-compliant Tai Ahom font";
    maintainers = with maintainers; [ mathnerd314 ];
    license = licenses.ofl; # See font metadata
    platforms = platforms.all;
  };
};

# TODO: package others (Khamti Shan, Tai Aiton, Tai Phake, and/or Assam Tai)

}
