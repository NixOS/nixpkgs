{
  lib,
  stdenv,
  fetchFromGitHub,
  fetchpatch,
  pkg-config,
  glib,
  zlib,
  libpng,
  cmake,
  libxml2,
  python3,
}:

let
  version = "0.3.3";
  pname = "lensfun";

  # Fetch a more recent version of the repo containing a more recent lens
  # database
  lensfunDatabase = fetchFromGitHub {
    owner = "lensfun";
    repo = "lensfun";
    rev = "ec9412d27d5fa8f377848a59c768b12c243cb80d";
    sha256 = "sha256-/u/3oQzac/dQrgFaiYvzT5uQ108XarkXnA2DByA5sic=";
  };

in
stdenv.mkDerivation {
  inherit pname version;

  src = fetchFromGitHub {
    owner = "lensfun";
    repo = "lensfun";
    rev = "v${version}";
    sha256 = "0ixf0f7qv0mc7zrw9w1sb60w833g4rqrfj8cjxwzv2vimqcksccz";
  };

  patches = [
    (fetchpatch {
      name = "fix-compilation-with-clang.patch";
      url = "https://github.com/lensfun/lensfun/commit/5c2065685a22f19f8138365c0e5acf0be8329c02.patch";
      sha256 = "sha256-tAOCNL37pKE7hfQCu+hUTKLFnRHWF5Dplqf+GaucG+4=";
    })
  ];

  # replace database with a more recent snapshot
  # the mastr branch uses version 2 profiles, while 0.3.3 requires version 1 profiles,
  # so we run the conversion tool the project provides,
  # then untar the verson 1 profiles into the source dir before we build
  prePatch = ''
    rm -R data/db
    python3 ${lensfunDatabase}/tools/lensfun_convert_db_v2_to_v1.py $TMPDIR ${lensfunDatabase}/data/db
    mkdir -p data/db
    tar xvf $TMPDIR/db/version_1.tar -C data/db
    date +%s > data/db/timestamp.txt
  '';

  nativeBuildInputs = [
    cmake
    pkg-config
    python3
    python3.pkgs.lxml # For the db converison
  ];

  buildInputs = [
    glib
    zlib
    libpng
  ];

  cmakeFlags = [ "-DINSTALL_HELPER_SCRIPTS=OFF" ];

  meta = with lib; {
    platforms = platforms.linux ++ platforms.darwin;
    maintainers = with maintainers; [ flokli ];
    license = lib.licenses.lgpl3;
    description = "An opensource database of photographic lenses and their characteristics";
    homepage = "https://lensfun.github.io";
  };
}
