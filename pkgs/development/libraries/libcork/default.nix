{ stdenv
, fetchFromGitHub
, cmake
, lib
, pkg-config
, check
}:
stdenv.mkDerivation rec {
  pname = "libcork";
  version = "1.0.0--rc3";

  src = fetchFromGitHub {
    owner = "dcreager";
    repo = pname;
    rev = version;
    sha256 = "152gqnmr6wfmflf5l6447am4clmg3p69pvy3iw7yhaawjqa797sk";
  };

  # N.B. We need to create this file, otherwise it tries to use git to
  # determine the package version, which we do not want.
  #
  # N.B. We disable tests by force, since their build is broken.
  postPatch = ''
    echo "${version}" > .version-stamp
    echo "${version}" > .commit-stamp
    sed -i '/add_subdirectory(tests)/d' ./CMakeLists.txt
  '';

  nativeBuildInputs = [ cmake pkg-config ];
  buildInputs = [ check ];

  doCheck = false;

  postInstall = ''
    ln -s $out/lib/libcork.so $out/lib/libcork.so.1
  '';

  meta = with lib; {
    homepage = "https://github.com/dcreager/libcork";
    description = "A simple, easily embeddable cross-platform C library";
    license = licenses.bsd3;
    platforms = platforms.unix;
    maintainers = with maintainers; [ lovesegfault ];
  };
}
