{ lib, stdenv, fetchFromGitHub, fetchpatch, cmake, doxygen, qt4, qjson }:

stdenv.mkDerivation rec {
  pname = "libechonest";
  version = "2.3.1";

  src = fetchFromGitHub {
    owner = "lfranchi";
    repo = pname;
    rev = version;
    sha256 = "0xbavf9f355dl1d3qv59x4ryypqrdanh9xdvw2d0q66l008crdkq";
  };

  patches = [
    (fetchpatch {
      url = "https://github.com/lfranchi/libechonest/commit/009514f65044823ef29045397d4b58dd04d09977.patch";
      sha256 = "0dmmpi7hixdngwiv045ilqrzyzkf56xpfyihcsx5i3xya2m0mynx";
    })
    (fetchpatch {
      url = "https://github.com/lfranchi/libechonest/commit/3ce779536d56a163656e8098913f923e6cda2b5c.patch";
      sha256 = "1vasd3sgqah562vxk71jibyws5cbihjjfnffd50qvdm2xqgvbx94";
    })
  ];

  nativeBuildInputs = [ cmake doxygen ];
  buildInputs = [ qt4 qjson ];

  doCheck = false; # requires network access

  meta = {
    description = "A C++/Qt wrapper around the Echo Nest API";
    homepage = "https://projects.kde.org/projects/playground/libs/libechonest";
    license = lib.licenses.gpl2Plus;
    platforms = lib.platforms.unix;
  };
}
