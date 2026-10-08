{
  buildAstalModule,
  astal3,
  io,

  meson,
  ninja,
  pkg-config,
}:
(buildAstalModule {
  name = "gjs";
  sourceRoot = "lang/gjs";
  meta.description = "Astal module for GJS";
}).overrideAttrs
  {
    # Remove all unused here inputs
    nativeBuildInputs = [
      meson
      ninja
      pkg-config
    ];
    buildInputs = [
      astal3
      io
    ];
    propagatedBuildInputs = [ ];
  }
