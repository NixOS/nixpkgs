{ autoreconfHook
, fetchFromGitHub
, fetchpatch
, lib
, nix-update-script
, pkg-config
, stdenv
}:

stdenv.mkDerivation rec {
  pname = "gensio";
  version = "2.2.1";

  src = fetchFromGitHub {
    owner = "cminyard";
    repo = pname;
    rev = "v${version}";
    sha256 = "083khzvyvcgi9j99hbaswglivm9s6dly6spjvisvyacavaybgwgb";
  };

  patches =  [
    # Fix compilation without openipmi, can be dropped for the next release.
    (fetchpatch {
      url = "https://github.com/cminyard/gensio/commit/12f6203e6f7aa42172177d7b0870777b605af8d9.patch";
      sha256 = "19dr4iacccc4il3asdxkag6cj2yc4bxd8p451syfxdm6289rwxic";
    })
  ];

  passthru = {
    updateScript = nix-update-script {
      attrPath = pname;
    };
  };

  configureFlags = [
    "--with-python=no"
  ];

  nativeBuildInputs = [ autoreconfHook pkg-config ];

  meta = with lib; {
    description = "General Stream I/O";
    homepage = "https://sourceforge.net/projects/ser2net/";
    license = licenses.gpl2;
    maintainers = with maintainers; [ emantor ];
    platforms = with platforms; linux;
  };
}
