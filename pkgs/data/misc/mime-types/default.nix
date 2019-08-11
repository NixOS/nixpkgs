{ stdenv, fetchzip }:

let
  version = "9";
in fetchzip rec {
  name = "mime-types-${version}";
  url = "https://mirrors.kernel.org/gentoo/distfiles/${name}.tar.bz2";
  postFetch = ''
    mkdir -p $out/etc
    tar xjvf $downloadedFile --directory=$out/etc --strip-components=1
  '';
  sha256 = "0gyla4wfiaccs0qh0hw7n08kdpnkkssglcg0z2jblb2lsdr4qna0";

  meta = with stdenv.lib; {
    description = "A database of common mappings of file extensions to MIME types";
    homepage = https://packages.gentoo.org/packages/app-misc/mime-types;
    license = licenses.gpl2;
    maintainers = with maintainers; [ peterhoeg ];
    platforms = platforms.all;
  };
}
