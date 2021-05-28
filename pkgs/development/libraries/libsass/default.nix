{ stdenv, fetchFromGitHub, autoreconfHook }:

stdenv.mkDerivation rec {
  pname = "libsass";
  version = "3.6.4";

  src = fetchFromGitHub {
    owner = "sass";
    repo = pname;
    rev = version;
    sha256 = "074kvacdan85h4qrvsk97575ys9xgkc044gplz3m6vn4a8pcl2rn";
    # Remove unicode file names which leads to different checksums on HFS+
    # vs. other filesystems because of unicode normalisation.
    extraPostFetch = ''
      rm -r $out/test/e2e/unicode-pwd
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
