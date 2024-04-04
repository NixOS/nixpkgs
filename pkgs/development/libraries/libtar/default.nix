{ lib, stdenv, fetchgit, fetchpatch, autoreconfHook }:

stdenv.mkDerivation rec {
  version = "1.2.20";
  pname = "libtar";

  # Maintenance repo for libtar (Arch Linux uses this)
  src = fetchgit {
    url = "git://repo.or.cz/libtar.git";
    rev = "refs/tags/v${version}";
    sha256 = "1pjsqnqjaqgkzf1j8m6y5h76bwprffsjjj6gk8rh2fjsha14rqn9";
  };

  patches = let
    fp =  name: sha256:
      fetchpatch {
        url = "https://sources.debian.net/data/main/libt/libtar/1.2.20-4/debian/patches/${name}.patch";
        inherit sha256;
      };
    in [
      (fetchpatch {
        name = "no_static_buffers.patch";
        url = "https://src.fedoraproject.org/rpms/libtar/raw/e25b692fc7ceaa387dafb865b472510754f51bd2/f/libtar-1.2.20-no-static-buffer.patch";
        sha256 = "sha256-QcWOgdkNlALb+YDVneT1zCNAMf4d8IUm2kUUUy2VvJs=";
      })
      (fp "no_maxpathlen"             "11riv231wpbdb1cm4nbdwdsik97wny5sxcwdgknqbp61ibk572b7")
      (fp "CVE-2013-4420"             "0d010190bqgr2ggy02qwxvjaymy9a22jmyfwdfh4086v876cbxpq")
      (fp "th_get_size-unsigned-int"  "1ravbs5yrfac98mnkrzciw9hd2fxq4dc07xl3wx8y2pv1bzkwm41")
      (fetchpatch {
        name = "CVE-2021-33643_CVE-2021-33644.patch";
        url = "https://src.fedoraproject.org/rpms/libtar/raw/e25b692fc7ceaa387dafb865b472510754f51bd2/f/libtar-1.2.20-CVE-2021-33643-CVE-2021-33644.patch";
        sha256 = "sha256-HdjotTvKJNntkdcV+kR08Ht/MyNeB6qUT0qo67BBOVA=";
      })
      (fetchpatch {
        name = "CVE-2021-33645_CVE-2021-33646_CVE-2021-33640.patch";
        url = "https://src.fedoraproject.org/rpms/libtar/raw/e25b692fc7ceaa387dafb865b472510754f51bd2/f/libtar-1.2.20-CVE-2021-33645-CVE-2021-33646.patch";
        sha256 = "sha256-p9DEFAL5Y+Ldy5c9Wj9h/BSg4TDxIxCjCQJD+wGQ7oI=";
      })
    ];

  nativeBuildInputs = [ autoreconfHook ];
  buildInputs = [ ];

  meta = with lib; {
    description = "C library for manipulating POSIX tar files";
    mainProgram = "libtar";
    homepage = "https://repo.or.cz/libtar";
    license = licenses.bsd3;
    platforms = with platforms; linux ++ darwin;
    maintainers = [ maintainers.bjornfor ];
  };
}
