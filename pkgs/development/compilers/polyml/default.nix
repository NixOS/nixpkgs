{ stdenv, fetchFromGitHub, fetchpatch, autoreconfHook, gmp, libffi }:

stdenv.mkDerivation rec {
  pname = "polyml";
  version = "5.8";

  prePatch = stdenv.lib.optionalString stdenv.isDarwin ''
    substituteInPlace configure.ac --replace stdc++ c++
  '';

  patches = [
    (fetchpatch {
      name = "new-libffi-FFI_SYSV.patch";
      url = "https://github.com/polyml/polyml/commit/ad32de7f181acaffaba78d5c3d9e5aa6b84a741c.patch";
      sha256 = "007q3r2h9kfh3c1nv0dyhipmak44q468ab9bwnz4kk4a2dq76n8v";
    })
  ];

  buildInputs = [ libffi gmp ];

  nativeBuildInputs = stdenv.lib.optional stdenv.isDarwin autoreconfHook;

  configureFlags = [
    "--enable-shared"
    "--with-system-libffi"
    "--with-gmp"
  ];

  src = fetchFromGitHub {
    owner = "polyml";
    repo = "polyml";
    rev = "v${version}";
    sha256 = "1s7q77bivppxa4vd7gxjj5dbh66qnirfxnkzh1ql69rfx1c057n3";
  };

  meta = with stdenv.lib; {
    description = "Standard ML compiler and interpreter";
    longDescription = ''
      Poly/ML is a full implementation of Standard ML.
    '';
    homepage = https://www.polyml.org/;
    license = licenses.lgpl21;
    platforms = with platforms; (linux ++ darwin);
    maintainers = with maintainers; [ maggesi kovirobi ];
  };
}
