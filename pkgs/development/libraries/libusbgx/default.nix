{
  stdenv,
  lib,
  fetchFromGitHub,
  cmake,
  bash-completion,
  pkg-config,
  libconfig,
  autoreconfHook,
}:
stdenv.mkDerivation {
  pname = "libusbgx";
  version = "unstable-2021-10-31";
  src = fetchFromGitHub {
    owner = "linux-usb-gadgets";
    repo = "libusbgx";
    rev = "060784424609d5a4e3bce8355f788c93f09802a5";
    sha256 = "172qh8gva17jr18ldhf9zi960w2bqzmp030w6apxq57c9nv6d8k7";
  };
  nativeBuildInputs = [
    autoreconfHook
    pkg-config
  ];
  buildInputs = [ libconfig ];
  meta = {
    description = "C library encapsulating the kernel USB gadget-configfs userspace API functionality";
    license = with lib.licenses; [
      lgpl21Plus # library
      gpl2Plus # examples
    ];
    maintainers = with lib.maintainers; [ lheckemann ];
    platforms = lib.platforms.linux;
  };
}
