{ stdenv, fetchurl, fetchFromGitHub, fetchpatch, zlib, expat, gettext
, autoconf }:

stdenv.mkDerivation rec {
  name = "exiv2-0.26.2018.06.09";

    #url = "http://www.exiv2.org/builds/${name}-trunk.tar.gz";
  src = fetchFromGitHub rec {
    owner = "exiv2";
    repo  = "exiv2";
    rev = "4aa57ad";
    sha256 = "1kblpxbi4wlb0l57xmr7g23zn9adjmfswhs6kcwmd7skwi2yivcd";
  };

  patches = [
    (fetchurl rec {
      name = "CVE-2017-9239.patch";
      url = let patchname = "0006-1296-Fix-submitted.patch";
          in "https://src.fedoraproject.org/lookaside/pkgs/exiv2/${patchname}"
          + "/sha512/${sha512}/${patchname}";
      sha512 = "3f9242dbd4bfa9dcdf8c9820243b13dc14990373a800c4ebb6cf7eac5653cfef"
             + "e6f2c47a94fbee4ed24f0d8c2842729d721f6100a2b215e0f663c89bfefe9e32";
    })
    # Two backports from master, submitted as https://github.com/Exiv2/exiv2/pull/398
    (fetchpatch {
      name = "CVE-2018-12264.diff";
      url = "https://github.com/vcunat/exiv2/commit/fd18e853.diff";
      sha256 = "0y7ahh45lpaiazjnfllndfaa5pyixh6z4kcn2ywp7qy4ra7qpwdr";
    })
    (fetchpatch {
      name = "CVE-2018-12265.diff";
      url = "https://github.com/vcunat/exiv2/commit/9ed1671bd4.diff";
      sha256 = "1cn446pfcgsh1bn9vxikkkcy1cqq7ghz2w291h1094ydqg6w7q6w";
    })
  ];

  postPatch = "patchShebangs ./src/svn_version.sh";

  preConfigure = "make config"; # needed because not using tarball

  outputs = [ "out" "dev" ];

  nativeBuildInputs = [
    gettext
    autoconf # needed because not using tarball
  ];
  propagatedBuildInputs = [ zlib expat ];

  meta = with stdenv.lib; {
    homepage = http://www.exiv2.org/;
    description = "A library and command-line utility to manage image metadata";
    platforms = platforms.all;
    license = licenses.gpl2Plus;
  };
}
