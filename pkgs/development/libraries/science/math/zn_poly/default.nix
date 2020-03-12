{ stdenv
, lib
, fetchFromGitLab
, fetchpatch
, gmp
, python2
, tune ? false # tune to hardware, impure
}:

stdenv.mkDerivation rec {
  version = "0.9.1";
  pname = "zn_poly";

  # sage has picked up the maintenance (bug fixes and building, not development)
  # from the original, now unmaintained project which can be found at
  # http://web.maths.unsw.edu.au/~davidharvey/code/zn_poly/
  src = fetchFromGitLab {
    owner = "sagemath";
    repo = "zn_poly";
    rev = version;
    sha256 = "0ra5vy585bqq7g3317iw6fp44iqgqvds3j0l1va6mswimypq4vxb";
  };

  buildInputs = [
    gmp
  ];

  nativeBuildInputs = [
    python2 # needed by ./configure to create the makefile
  ];

  # name of library file ("libzn_poly.so")
  libbasename = "libzn_poly";
  libext = stdenv.targetPlatform.extensions.sharedLibrary;

  makeFlags = [ "CC=cc" ];

  # Tuning (either autotuning or with hand-written paramters) is possible
  # but not implemented here.
  # It seems buggy anyways (see homepage).
  buildFlags = [ "all" "${libbasename}${libext}" ];

  configureFlags = lib.optionals (!tune) [
    "--disable-tuning"
  ];

  patches = [
    # fix format-security by not passing variables directly to printf
    # https://gitlab.com/sagemath/zn_poly/merge_requests/1
    (fetchpatch {
      name = "format-security.patch";
      url = "https://gitlab.com/timokau/zn_poly/commit/1950900a80ec898d342b8bcafa148c8027649766.patch";
      sha256 = "1gks9chvsfpc6sg5h3nqqfia4cgvph7jmj9dw67k7dk7kv9y0rk1";
    })
  ];

  # `make install` fails to install some header files and the lib file.
  installPhase = ''
    mkdir -p "$out/include/zn_poly"
    mkdir -p "$out/lib"
    cp "${libbasename}"*"${libext}" "$out/lib"
    cp include/*.h "$out/include/zn_poly"
  '';

  doCheck = true;

  meta = with lib; {
    homepage = http://web.maths.unsw.edu.au/~davidharvey/code/zn_poly/;
    description = "Polynomial arithmetic over Z/nZ";
    license = with licenses; [ gpl3 ];
    maintainers = with maintainers; [ timokau ];
    platforms = platforms.unix;
  };
}
