{ stdenv, lib, fetchFromGitHub, autoreconfHook, perl, cracklib, python3, fetchpatch }:

stdenv.mkDerivation rec {
  pname = "libpwquality";
  version = "1.4.2";

  src = fetchFromGitHub {
    owner = "libpwquality";
    repo = "libpwquality";
    rev = "${pname}-${version}";
    sha256 = "0n4pjhm7wfivk0wizggaxq4y4mcxic876wcarjabkp5z9k14y36h";
  };

  nativeBuildInputs = [ autoreconfHook perl python3 ];
  buildInputs = [ cracklib ];

  patches = lib.optional stdenv.hostPlatform.isStatic [
    (fetchpatch {
      name = "static-build.patch";
      url = "https://github.com/libpwquality/libpwquality/pull/40.patch";
      sha256 = "1ypccq437wxwgddd98cvd330jfm7jscdlzlyxgy05g6yzrr68xyk";
    })
  ];

  configureFlags = lib.optional stdenv.hostPlatform.isStatic [
    # Python binding generates a shared library which are unavailable with musl build
    "--disable-python-bindings"
  ];

  meta = with lib; {
    description = "Password quality checking and random password generation library";
    homepage = "https://github.com/libpwquality/libpwquality";
    license = licenses.bsd3;
    platforms = platforms.unix;
  };
}
