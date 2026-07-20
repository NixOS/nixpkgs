{
  lib,
  qtModule,
  qtbase,
  llvmPackages,
}:

qtModule {
  pname = "qtmacextras";
  propagatedBuildInputs = [ qtbase ];

  # TODO: Remove once #536365 reaches this branch
  nativeBuildInputs = [ llvmPackages.lld ];
  env.NIX_CFLAGS_LINK = "-fuse-ld=lld";

  meta = {
    maintainers = [ ];
    platforms = lib.platforms.darwin;
  };
}
