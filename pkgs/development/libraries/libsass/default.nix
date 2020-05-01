{ stdenv, fetchFromGitHub, autoreconfHook }:

stdenv.mkDerivation rec {
  pname = "libsass";
  version = "3.6.3";

  src = fetchFromGitHub {
    owner = "sass";
    repo = pname;
    rev = version;
    sha256 = "1q6lvd8sj5k5an32qir918pa5khhcb8h08dzrg1bcxmw7a23j514";
    # Exclude unicode file names which leads to different checksums on HFS+
    # vs. other filesystems because of unicode normalisation.
    # Or leads to a collision when moving the unpacked source
    # from a tmpfs $TMPDIR to a ZFS Nix store using normalization=formD.
    postFetch = ''
      tar -C "$out" \
       --strip-components=1 \
       --exclude=test/e2e/unicode-pwd \
       -xf "$downloadedFile"
    '';
  };

  preConfigure = ''
    export LIBSASS_VERSION=${version}
  '';

  nativeBuildInputs = [ autoreconfHook ];

  meta = with stdenv.lib; {
    description = "A C/C++ implementation of a Sass compiler";
    homepage = "https://github.com/sass/libsass";
    license = licenses.mit;
    maintainers = with maintainers; [ codyopel offline ];
    platforms = platforms.unix;
  };
}
