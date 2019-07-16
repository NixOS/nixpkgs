{ stdenv, fetchurl, libiconv, fetchpatch }:

stdenv.mkDerivation rec {
  name = "wavpack-${version}";
  version = "5.1.0";

  enableParallelBuilding = true;

  buildInputs = stdenv.lib.optional stdenv.isDarwin libiconv;

  src = fetchurl {
    url = "http://www.wavpack.com/${name}.tar.bz2";
    sha256 = "0i19c6krc0p9krwrqy9s5xahaafigqzxcn31piidmlaqadyn4f8r";
  };

  patches = [
    (fetchpatch {
      url = "https://github.com/dbry/WavPack/commit/26cb47f99d481ad9b93eeff80d26e6b63bbd7e15.patch";
      name = "CVE-2018-10536-CVE-2018-10537.patch";
      sha256 = "0s0fyycd4x7pw4vl1yp2vp4zrlk04j85idvnxz5h96fj6196anw6";
    })
    (fetchpatch {
      url = "https://github.com/dbry/WavPack/commit/6f8bb34c2993a48ab9afbe353e6d0cff7c8d821d.patch";
      name = "CVE-2018-10538-CVE-2018-10539-CVE-2018-10540.patch";
      sha256 = "03qzmaq9mwiqbzrx1lvkgkhz3cjv7dky1b4lka3d5q2rwdlyw5qk";
    })
    (fetchpatch {
      url = "https://github.com/dbry/WavPack/commit/d5bf76b5a88d044a1be1d5656698e3ba737167e5.patch";
      name = "CVE-2018-6767.patch";
      sha256 = "158c60i188kbxl0hzb7g74g21pknz7fk429vnbbx9zk1mlyyyl5b";
    })
    (fetchpatch {
      url = "https://github.com/dbry/WavPack/commit/bf408e95f43fafdcef42c3f5f9c9d0e6ab0331b9.patch";
      name = "CVE-2019-11498-1.patch";
      sha256 = "161dw759v1lzbhj7daw2gbmcji8s0njpa65xmqhqw73bwpzb3xkd";
    })
    (fetchpatch {
      url = "https://github.com/dbry/WavPack/commit/cd353bccafb1274a525c3536aaff8c48c3a33aa0.patch";
      name = "CVE-2019-11498-2.patch";
      sha256 = "120sb1iqkq2gadh0qydqvca4vwx31zb7gk1d0nm0y5agav2ai0dk";
    })
    (fetchpatch {
      url = "https://github.com/dbry/WavPack/commit/4c0faba32fddbd0745cbfaf1e1aeb3da5d35b9fc.patch";
      name = "CVE-2019-11498-3.patch";
      sha256 = "12744yn1035mf7wzgqrkyadw5mwqf9v34ckj2m5sirk97k47k0wa";
    })
    (fetchpatch {
      url = "https://github.com/dbry/WavPack/commit/bc6cba3f552c44565f7f1e66dc1580189addb2b4.patch";
      name = "CVE-2019-11498-4.patch";
      sha256 = "0qdw071b14hmxkjw6kn83d8hzq89l3hqh64pl1f1wb8m51w5xfg7";
    })
    (fetchpatch {
      url = "https://github.com/dbry/WavPack/commit/070ef6f138956d9ea9612e69586152339dbefe51.patch";
      name = "CVE-2018-19840.patch";
      sha256 = "08y27py8hnki74ad8wbknnd36vj5pzzcm2vk3ngcbsjnj7x5mffz";
    })
    (fetchpatch {
      url = "https://github.com/dbry/WavPack/commit/bba5389dc598a92bdf2b297c3ea34620b6679b5b.patch";
      name = "CVE-2018-19841.patch";
      sha256 = "08gx5xx51bi86cqqy7cv1d25k669a7wnkksasjspphwkpwkcxymy";
    })
  ];

  meta = with stdenv.lib; {
    description = "Hybrid audio compression format";
    homepage    = http://www.wavpack.com/;
    license     = licenses.bsd3;
    platforms   = platforms.unix;
    maintainers = with maintainers; [ codyopel ];
  };
}
