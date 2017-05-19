{ mkDerivation, lib, copyPathsToStore, fetchurl, qtbase, qtscript, cmake }:

mkDerivation rec {
  name = "grantlee-${version}";
  version = "5.1.0";
  grantleeCompatVersion = "5.1";
  grantleePluginPrefix = "lib/grantlee/${grantleeCompatVersion}";

  src = fetchurl {
    url = "https://github.com/steveire/grantlee/archive/v${version}.tar.gz";
    sha256 = "1lf9rkv0i0kd7fvpgg5l8jb87zw8dzcwd1liv6hji7g4wlpmfdiq";
    name = "${name}.tar.gz";
  };

  patches = copyPathsToStore (lib.readPathsFromFile ./. ./series);

  buildInputs = [ qtbase qtscript ];
  nativeBuildInputs = [ cmake ];

  outputs = [ "out" "dev" "bin" ];
  postInstall = ''
    moveToOutput "$grantleePluginPrefix" "$bin"

    # CMake checks that the provided libraries and plugins exist
    # Link libraries into $dev to satisfy CMake
    mkdir -p $dev/lib
    find $out/lib -name '*.so.*' -exec ln -s \{\} $dev/lib \;

    # Link plugins into $dev to satisfy CMake
    ln -s $bin/lib/grantlee $dev/lib
  '';

  setupHook = ./setup-hook.sh;

  meta = with lib; {
    description = "Qt5 port of Django template system";
    longDescription = ''
      Grantlee is a plugin based String Template system written using the Qt
      framework. The goals of the project are to make it easier for application
      developers to separate the structure of documents from the data they
      contain, opening the door for theming.

      The syntax is intended to follow the syntax of the Django template system,
      and the design of Django is reused in Grantlee.'';

    homepage = http://gitorious.org/grantlee;
    maintainers = [ maintainers.ttuegel ];
    inherit (qtbase.meta) platforms;
  };
}
