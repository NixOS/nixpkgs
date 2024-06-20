{ lib
, stdenv
, fetchFromGitHub
, autoreconfHook
, pkg-config
, cmocka
}:

stdenv.mkDerivation rec {
  pname = "libdaq";
  version = "3.0.11";

  src = fetchFromGitHub {
    owner = "snort3";
    repo = "libdaq";
    rev = "v${version}";
    sha256 = "sha256-3Pk0zKFztY/m4IFlGQ1t0KwF8kj3j9jZCjglsdtjbXc=";
  };

  nativeBuildInputs = [ autoreconfHook pkg-config ];

  configurePhase = ''
    ./configure --prefix=$out --disable-fst-module
  '';

  meta = with lib; {
    homepage = "https://github.com/snort3/libdaq";
    license = licenses.gpl2;
    description = "The Data AcQuisition Library";
    longDescription = ''
      LibDAQ is a pluggable abstraction layer for interacting with a data source
      (traditionally a network interface or network data plane).
      Applications using LibDAQ use the library API defined in daq.h to load,
      configure, and interact with pluggable DAQ modules.
    '';
    platforms = [ "x86_64-linux" ];
    maintainers = with maintainers; [ cariandrum22 ];
  };
}
