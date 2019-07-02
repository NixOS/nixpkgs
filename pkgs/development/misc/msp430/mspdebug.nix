{ stdenv
, fetchFromGitHub
, libusb-compat-0_1
, readline ? null
, enableReadline ? true
, hidapi ? null
, pkg-config ? null
}:

assert stdenv.isDarwin -> hidapi != null && pkg-config != null;
assert enableReadline -> readline != null;

stdenv.mkDerivation rec {
  version = "0.25";
  pname = "mspdebug";
  src = fetchFromGitHub {
    owner = "dlbeer";
    repo = "mspdebug";
    rev = "v${version}";
    sha256 = "0prgwb5vx6fd4bj12ss1bbb6axj2kjyriyjxqrzd58s5jyyy8d3c";
  };

  enableParallelBuilding = true;
  nativeBuildInputs = stdenv.lib.optional stdenv.isDarwin pkg-config;
  buildInputs = [ libusb-compat-0_1 ]
  ++ stdenv.lib.optional stdenv.isDarwin hidapi
  ++ stdenv.lib.optional enableReadline readline;

  postPatch = stdenv.lib.optionalString stdenv.isDarwin ''
    # TODO: remove once a new 0.26+ release is made
    substituteInPlace drivers/tilib_api.c --replace .so ${stdenv.hostPlatform.extensions.sharedLibrary}

    # Makefile only uses pkg-config if it detects homebrew
    substituteInPlace Makefile --replace brew true
  '';

  installFlags = [ "PREFIX=$(out)" "INSTALL=install" ];
  makeFlags = [ "UNAME_S=$(unameS)" ] ++
    stdenv.lib.optional (!enableReadline) "WITHOUT_READLINE=1";
  unameS = stdenv.lib.optionalString stdenv.isDarwin "Darwin";

  meta = with stdenv.lib; {
    description = "A free programmer, debugger, and gdb proxy for MSP430 MCUs";
    homepage = "https://dlbeer.co.nz/mspdebug/";
    license = licenses.gpl2;
    platforms = platforms.all;
    maintainers = with maintainers; [ aerialx ];
  };
}
