{
  lib,
  stdenv,
  pkg-config,
  fetchFromCodeberg,
  coreutils,
  gnumake,
  zstd,
  autoreconfHook,
  iptables,
  kernel ? null,
  ...
}:
stdenv.mkDerivation (finalAttrs: {
  pname = "xtables-addons";
  version = "3.31";

  __structuredAttrs = true;

  strictDeps = true;

  src = fetchFromCodeberg {
    owner = "jengelh";
    repo = finalAttrs.pname;
    rev = "v${finalAttrs.version}";
    hash = "sha256-jjcpiSwTL3wvDFzaUpaCsA543c+eloQ9KVgWJE0sEv8=";
  };

  nativeBuildInputs = [
    coreutils
    gnumake
    zstd
    autoreconfHook
    pkg-config
  ]
  ++ lib.optionals (kernel != null) kernel.moduleBuildDependencies;

  buildInputs = [
    ## Prevent infinite recursion
    (iptables.override { xtablesAddons = false; })
  ];

  hardeningDisable = lib.optionals (kernel != null) [
    "pic"
    "format"
  ];

  env = {
    DESTDIR = placeholder "out";
  };

  configureFlags = [
    ## NOTE: it would be cool to re-use `DESTDIR` but Makefiles do not like it
    # "--libdir=$DESTDIR/lib"
    "--libdir=${placeholder "out"}/lib"
  ]
  ++ lib.optionals (kernel == null) [
    "--without-kbuild"
  ]
  ++ (lib.optionals (kernel != null) [
    "--with-kbuild=${kernel.dev}/lib/modules/${kernel.modDirVersion}/build"
  ]);

  makeFlags = lib.optionals (kernel != null) [
    "KERNELRELEASE=${kernel.modDirVersion}"
    "KERNEL_DIR=${kernel.dev}/lib/modules/${kernel.modDirVersion}/build"
    "INSTALL_MOD_PATH=$(out)"
  ];

  installFlags = [
    "xtlibdir=lib/xtables"
  ];

  postInstall = ''
    find "$out" -type f -name '*.ko' -exec printf '%s\n' {} \; ;
  '';

  meta = {
    description = "Xtables-addons is a set of extensions that were not accepted in the Linux kernel and/or main Xtables/iptables package";
    homepage = "https://inai.de/projects/xtables-addons/";
    changelog = "https://codeberg.org/jengelh/xtables-addons/src/tag/v${finalAttrs.version}";
    license = lib.licenses.gpl2Only;
    maintainers = with lib.maintainers; [ S0AndS0 ];
  };
})
