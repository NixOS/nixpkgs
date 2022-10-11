{ lib
, stdenv
, fetchFromGitLab
, guile
, libgit2
, scheme-bytestructures
, autoreconfHook
, pkg-config
, texinfo
}:

stdenv.mkDerivation rec {
  pname = "guile-git";
  version = "0.5.2";

  src = fetchFromGitLab {
    owner = "guile-git";
    repo = pname;
    rev = "v${version}";
    sha256 = "x6apF9fmwzrkyzAexKjClOTFrbE31+fVhSLyFZkKRYU=";
  };

  nativeBuildInputs = [
    autoreconfHook pkg-config texinfo
  ];
  buildInputs = [
    guile
  ];
  propagatedBuildInputs = [
    libgit2 scheme-bytestructures
  ];
  doCheck = true;
  makeFlags = [ "GUILE_AUTO_COMPILE=0" ];

  enableParallelBuilding = true;

  # Skipping proxy tests since it requires network access.
  postConfigure = ''
    sed -i -e '94i (test-skip 1)' ./tests/proxy.scm
  '';

  meta = with lib; {
    description = "Bindings to Libgit2 for GNU Guile";
    homepage = "https://gitlab.com/guile-git/guile-git";
    license = licenses.gpl3Plus;
    maintainers = with maintainers; [ ethancedwards8 ];
    platforms = platforms.linux;
  };
}

