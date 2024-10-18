{ stdenv
, lib
, fetchFromGitHub
, autoreconfHook
, pkg-config
, docSupport ? true
, doxygen
, libftdi1
}:

stdenv.mkDerivation rec {
  pname = "libexsid";
  version = "2.1";

  src = fetchFromGitHub {
    owner = "libsidplayfp";
    repo = "exsid-driver";
    rev = version;
    sha256 = "1qbiri549fma8c72nmj3cpz3sn1vc256kfafnygkmkzg7wdmgi7r";
  };

  outputs = [ "out" ]
    ++ lib.optional docSupport "doc";

  nativeBuildInputs = [ autoreconfHook pkg-config ]
    ++ lib.optional docSupport doxygen;

  buildInputs = [ libftdi1 ];

  enableParallelBuilding = true;

  installTargets = [ "install" ]
    ++ lib.optional docSupport "doc";

  postInstall = lib.optionalString docSupport ''
    mkdir -p $doc/share/libexsid/doc
    cp -r docs/html $doc/share/libexsid/doc/
  '';

  meta = with lib; {
    description = "Driver for exSID USB";
    homepage = "http://hacks.slashdirt.org/hw/exsid/";
    license = licenses.gpl2Plus;
    maintainers = with maintainers; [ OPNA2608 ];
    platforms = platforms.all;
  };
}
