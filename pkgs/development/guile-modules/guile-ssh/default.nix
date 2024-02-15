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

stdenv.mkDerivation (finalAttrs: {
  pname = "guile-ssh";
  version = "0.16.3";

  src = fetchFromGitHub {
    owner = "artyom-poptsov";
    repo = "guile-ssh";
    rev = "v${finalAttrs.version}";
    hash = "sha256-P29U88QrCjoyl/wdTPZbiMoykd/v6ul6CW/IJn9UAyw=";
  };

  patches = [
    (fetchpatch {
      url = "https://github.com/artyom-poptsov/guile-ssh/pull/31/commits/38636c978f257d5228cd065837becabf5da16854.patch";
      hash = "sha256-J+TDgdjihKoEjhbeH+BzqrHhjpVlGdscRj3L/GAFgKg=";
    })
  ];

  strictDeps = true;

  nativeBuildInputs = [
    autoreconfHook
    guile
    pkg-config
    texinfo
    which
  ];

  buildInputs = [
    guile
  ];

  propagatedBuildInputs = [
    libssh
  ];

  enableParallelBuilding = true;

  # FAIL: server-client.scm
  doCheck = !stdenv.isDarwin;

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
})
