{ stdenv, fetchgit, fetchpatch, autoreconfHook }:

stdenv.mkDerivation rec {
  version = "1.2.20";
  name = "libtar-${version}";

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
      (fp "no_static_buffers"         "0yv90bhvqjj0v650gzn8fbzhdhzx5z0r1lh5h9nv39wnww435bd0")
      (fp "no_maxpathlen"             "11riv231wpbdb1cm4nbdwdsik97wny5sxcwdgknqbp61ibk572b7")
      (fp "CVE-2013-4420"             "0d010190bqgr2ggy02qwxvjaymy9a22jmyfwdfh4086v876cbxpq")
      (fp "th_get_size-unsigned-int"  "1ravbs5yrfac98mnkrzciw9hd2fxq4dc07xl3wx8y2pv1bzkwm41")
    ];

  nativeBuildInputs = [ autoreconfHook ];
  buildInputs = [ ];

  meta = with stdenv.lib; {
    description = "C library for manipulating POSIX tar files";
    homepage = https://repo.or.cz/libtar;
    license = licenses.bsd3;
    platforms = with platforms; linux ++ darwin;
    maintainers = [ maintainers.bjornfor ];
  };
}
