{ lib, stdenv,
  fetchFromGitHub,
  autoreconfHook,
  bison,
  flex,
  glib,
  pkg-config,
  json_c,
  xen,
  libvirt,
  xenSupport ? true }:

stdenv.mkDerivation rec {
  pname = "libvmi";
  version = "0.12.0";
  libVersion = "0.0.12";

  src = fetchFromGitHub {
    owner = "libvmi";
    repo = "libvmi";
    rev = "v${version}";
    sha256 = "0wbi2nasb1gbci6cq23g6kq7i10rwi1y7r44rl03icr5prqjpdyv";
  };

  buildInputs = [ glib libvirt json_c ] ++ (lib.optional xenSupport xen);
  nativeBuildInputs = [ autoreconfHook bison flex pkg-config ];

  configureFlags = lib.optional (!xenSupport) "--disable-xen";

  # libvmi uses dlopen() for the xen libraries, however autoPatchelfHook doesn't work here
  postFixup = lib.optionalString xenSupport ''
    libvmi="$out/lib/libvmi.so.${libVersion}"
    oldrpath=$(patchelf --print-rpath "$libvmi")
    patchelf --set-rpath "$oldrpath:${lib.makeLibraryPath [ xen ]}" "$libvmi"
  '';

  meta = with lib; {
    homepage = "https://libvmi.com/";
    description = "C library for virtual machine introspection";
    longDescription = ''
      LibVMI is a C library with Python bindings that makes it easy to monitor the low-level
      details of a running virtual machine by viewing its memory, trapping on hardware events,
      and accessing the vCPU registers.
    '';
    license = with licenses; [ gpl3 lgpl3 ];
    platforms = platforms.linux;
    maintainers = with maintainers; [ ];
  };
}
