{ stdenv, fetchurl, fetchpatch }:

stdenv.mkDerivation rec {
  name = "libogg-1.3.4";

  src = fetchurl {
    url = "http://downloads.xiph.org/releases/ogg/${name}.tar.xz";
    sha256 = "1zlk33vxvxr0l9lhkbhkdwvylw96d2n0fnd3d8dl031hph9bqqy1";
  };

  outputs = [ "out" "dev" "doc" ];

  patches = stdenv.lib.optionals stdenv.isDarwin [
    # Fix unsigned typedefs on darwin. Remove with the next release https://github.com/xiph/ogg/pull/64
    (fetchpatch {
      url = "https://github.com/xiph/ogg/commit/c8fca6b4a02d695b1ceea39b330d4406001c03ed.patch";
      sha256 = "1s72g37y87x0a74zjji9vx2hyk86kr4f2l3m4y2fipvlf9348b3f";
    })
  ];

  meta = with stdenv.lib; {
    description = "Media container library to manipulate Ogg files";
    longDescription = ''
      Library to work with Ogg multimedia container format.
      Ogg is flexible file storage and streaming format that supports
      plethora of codecs. Open format free for anyone to use.
    '';
    homepage = "https://xiph.org/ogg/";
    license = licenses.bsd3;
    maintainers = [ maintainers.ehmry ];
    platforms = platforms.all;
  };
}
