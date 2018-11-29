{ stdenv, fetchurl, zlib }:

stdenv.mkDerivation rec {
  name = "kyotocabinet-1.2.76";

  src = fetchurl {
    url = "http://fallabs.com/kyotocabinet/pkg/${name}.tar.gz";
    sha256 = "0g6js20x7vnpq4p8ghbw3mh9wpqksya9vwhzdx6dnlf354zjsal1";
  };

  prePatch = stdenv.lib.optionalString stdenv.isDarwin ''
    substituteInPlace kccommon.h \
      --replace tr1/unordered_map unordered_map \
      --replace tr1/unordered_set unordered_set \
      --replace tr1::hash std::hash \
      --replace tr1::unordered_map std::unordered_map \
      --replace tr1::unordered_set std::unordered_set

    substituteInPlace lab/kcdict/Makefile --replace stdc++ c++
    substituteInPlace configure \
        --replace /usr/local/bin:/usr/local/sbin: "" \
        --replace /usr/bin:/usr/sbin: "" \
        --replace /bin:/sbin: "" \
        --replace stdc++ c++
  '';

  patches = [(fetchurl {
    name = "gcc6.patch";
    url = "https://src.fedoraproject.org/rpms/kyotocabinet/raw/master/f/kyotocabinet-1.2.76-gcc6.patch";
    sha256 = "1h5k38mkiq7lz8nd2gbn7yvimcz49g3z7phn1cr560bzjih8rz23";
  })];

  buildInputs = [ zlib ];

  meta = with stdenv.lib; {
    homepage = http://fallabs.com/kyotocabinet;
    description = "A library of routines for managing a database";
    license = licenses.gpl3;
    platforms = platforms.all;
    maintainers = with maintainers; [ wkennington ];
  };
}
