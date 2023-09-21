{ lib
, stdenv
, fetchFromGitHub
, fetchpatch
, guile
, libssh
, autoreconfHook
, pkg-config
, texinfo
, which
}:

stdenv.mkDerivation rec {
  pname = "guile-ssh";
  version = "0.16.3";

  src = fetchFromGitHub {
    owner = "artyom-poptsov";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-P29U88QrCjoyl/wdTPZbiMoykd/v6ul6CW/IJn9UAyw=";
  };

  patches = [
    (fetchpatch {
      url = "https://github.com/artyom-poptsov/guile-ssh/pull/31.patch";
      sha256 = "sha256-J+TDgdjihKoEjhbeH+BzqrHhjpVlGdscRj3L/GAFgKg=";
    })
  ];

  nativeBuildInputs = [
    autoreconfHook
    pkg-config
    texinfo
    which
  ];
  buildInputs = [ guile ];
  propagatedBuildInputs = [ libssh ];

  enableParallelBuilding = true;

  postInstall = ''
    mv $out/bin/*.scm $out/share/guile-ssh
    rmdir $out/bin
  '';

  meta = with lib; {
    description = "Bindings to Libssh for GNU Guile";
    homepage = "https://github.com/artyom-poptsov/guile-ssh";
    license = licenses.gpl3Plus;
    maintainers = with maintainers; [ ethancedwards8 foo-dogsquared ];
    platforms = guile.meta.platforms;
  };
}
