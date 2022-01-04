qt is a huge library,
so here are some hints to help with packaging of qt6

## splitBuildInstall

useful to modify post install phases, without recompiling (buildPhase)

alternative: impure build + ccache

## debugging cmake

```nix
  cmakeFlags = [ "--trace-expand" ];
```

this is really verbose. better write a logfile:

```
nix-build . -A qt6.qtdeclarative 2>&1 | tee build.log
```

example error:

```
CMake Error at /nix/store/km2fxg6swjmk4l5xfs15smj7phmlrd96-qtdeclarative-6.2.2-dev/lib/cmake/Qt6QmlTools/Qt6QmlToolsTargets.cmake:168 (message):
  The imported target "Qt6::qmldom" references the file

     "/nix/store/km2fxg6swjmk4l5xfs15smj7phmlrd96-qtdeclarative-6.2.2-dev/bin/qmldom"

  but this file does not exist.  Possible reasons include:
```

add `cmakeFlags = [ "--trace-expand" ];`

look for `/nix/store/km2fxg6swjmk4l5xfs15smj7phmlrd96-qtdeclarative-6.2.2-dev/bin/qmldom`

> ```/nix/store/km2fxg6swjmk4l5xfs15smj7phmlrd96-qtdeclarative-6.2.2-dev/lib/cmake/Qt6QmlTools/Qt6QmlToolsTargets-release.cmake(28):  set_target_properties(Qt6::qmldom PROPERTIES IMPORTED_LOCATION_RELEASE /nix/store/km2fxg6swjmk4l5xfs15smj7phmlrd96-qtdeclarative-6.2.2-dev/bin/qmldom```

read `/nix/store/km2fxg6swjmk4l5xfs15smj7phmlrd96-qtdeclarative-6.2.2-dev/lib/cmake/Qt6QmlTools/Qt6QmlToolsTargets-release.cmake`

line 28:

```cmake
set_target_properties(Qt6::qmldom PROPERTIES
  IMPORTED_LOCATION_RELEASE "${_QTDECLARATIVE_NIX_DEV}/bin/qmldom"
  )
```

2 solutions:

1. move `/bin/qmldom` to qtdeclarative.dev
  * this is the correct solution, because `out` should have only `/lib/*.so` files
2. patch `Qt6QmlToolsTargets-release.cmake` to point to `${_QTDECLARATIVE_NIX_OUT}/bin/qmldom`
  * see `postFixup` phase in `modules/qtdeclarative.nix`
  * regex: ```s+="s/\\\''${_IMPORT_PREFIX}\/(\.\/)?bin/\\\''${_''${moduleNAME}_NIX_DEV}\/bin/g;"```

solution 2 works, because currently, qmldom is in

```
$ find /nix/store/*-qtdeclarative-6.2.2*/ -path '*/bin/qmldom'
/nix/store/qaq67vr1lc351rvxipgn9vswqlbhv0id-qtdeclarative-6.2.2/bin/qmldom
```

i cannot remember why its not in the `dev` output ...
i guess that produced a cycle error
= circular dependency `out -> dev -> out`,
because of buggy library paths, see `ldd *.so`

get source of `Qt6QmlToolsTargets-release.cmake`:

```sh
ls /nix/store/*-qtdeclarative-*6.2.2*tar.xz
# /nix/store/3nnql1pp9gxrnir5i1jrbx1mims6ppy0-qtdeclarative-everywhere-src-6.2.2.tar.xz

cd $(mktemp -d)

tar xf /nix/store/*-qtdeclarative-*6.2.2*tar.xz

find . -name Qt6QmlToolsTargets-release.cmake
# no match -> file is generated on build

# look in cached buildPhase
ls /nix/store/*-qtdeclarative-*6.2.2/qtdeclarative-everywhere-src-6.2.2/
# ...

find /nix/store/*-qtdeclarative-*6.2.2/qtdeclarative-everywhere-src-6.2.2/ -name Qt6QmlToolsTargets-release.cmake
# /nix/store/j9sj7l4f83afjq8cag7202rwk4pmhav9-qtdeclarative-6.2.2/qtdeclarative-everywhere-src-6.2.2/build/CMakeFiles/Export/lib/cmake/Qt6QmlTools/Qt6QmlToolsTargets-release.cmake
```

line 28:

```
set_target_properties(Qt6::qmldom PROPERTIES
  IMPORTED_LOCATION_RELEASE "${_IMPORT_PREFIX}/bin/qmldom"
  )
```

prototyping the perl regex:

```
i='IMPORTED_LOCATION_RELEASE "${_IMPORT_PREFIX}/bin/qmldom"'
echo "$i" | perl -00 -p -e
```

escape hell:

```
nix string: escape $ -> ''$
''"s/\\\''${_IMPORT_PREFIX}\/(\.\/)?bin/\\\''${_''${moduleNAME}_NIX_DEV}\/bin/g;"''

bash string: moduleNAME=QTDECLARATIVE
"s/\\\${_IMPORT_PREFIX}\/(\.\/)?bin/\\\${_${moduleNAME}_NIX_DEV}\/bin/g;"

perl regex:
s/\${_IMPORT_PREFIX}\/(\.\/)?bin/\${_QTDECLARATIVE_NIX_DEV}\/bin/g;
```

in this case, we only must change the nix string, from NIX_DEV to NIX_OUT:

```diff
-''"s/\\\''${_IMPORT_PREFIX}\/(\.\/)?bin/\\\''${_''${moduleNAME}_NIX_DEV}\/bin/g;"''
+''"s/\\\''${_IMPORT_PREFIX}\/(\.\/)?bin/\\\''${_''${moduleNAME}_NIX_OUT}\/bin/g;"''
```

with `splitBuildInstall`,
the rebuild of qtdeclarative takes only about 2 minutes,
compared to 150 minutes for a full rebuild (dual core cpu)

## Failed to find Qt component "Quick"

QtQuick is provided by qtdeclarative

```
-- Could NOT find Qt6Quick (missing: Qt6Quick_DIR)
CMake Warning at /nix/store/r9ix52qw20ag8r6ym1zdfsybk4wqwdz8-qtbase-6.2.2-dev/lib/cmake/Qt6/Qt6Config.cmake:225 (message):
  Failed to find Qt component "Quick".

  Expected Config file at
  "/nix/store/r9ix52qw20ag8r6ym1zdfsybk4wqwdz8-qtbase-6.2.2-dev/lib/cmake/Qt6Quick/Qt6QuickConfig.cmake"
  does NOT exist
```

the requested cmake file is in package qtdeclarative:

```
$ find '/nix/store/'*-qtdeclarative-6.2.2* -path '*''/lib/cmake/Qt6Quick/Qt6QuickConfig.cmake'
/nix/store/km2fxg6swjmk4l5xfs15smj7phmlrd96-qtdeclarative-6.2.2-dev/lib/cmake/Qt6Quick/Qt6QuickConfig.cmake
```

solution:

```nix
  preConfigure = ''
    export QT_ADDITIONAL_PACKAGES_PREFIX_PATH="${qtdeclarative.dev}"
  '';
```

this is needed for:

* qtdeclarative
* qtsvg
* qt5compat
* qtwebsockets
* ...

example: `pkgs/applications/graphics/qimgv/default.nix`

```nix
  preConfigure = ''
    export QT_ADDITIONAL_PACKAGES_PREFIX_PATH="${qtsvg.dev}:${qt5compat.dev}"
  '';
```

ideally, this env var should be set by qt hooks in `pkgs/development/libraries/qt-6/hooks/`

this variable is used by qt's cmake files, see:

```
find /nix/store/*-qtbase-6.2.2* -name '*.cmake' -exec grep -Hn -C2 -F 'QT_ADDITIONAL_PACKAGES_PREFIX_PATH' '{}' \;
```

examples:

* pkgs/applications/graphics/qimgv/default.nix
* pkgs/development/libraries/qt-6/modules/qtwebengine.nix

## dependency WrapOpenGL could not be found

full error:

```
Qt6Gui could not be found because dependency WrapOpenGL could not be found.
```

add dependencies:

```nix
{ qtModule
, qtbase

# add this:
, libglvnd, libxkbcommon, vulkan-headers, libX11, libXcomposite
# TODO should be inherited from qtbase

}:
```

and

```nix
  buildInputs = [
    wayland pkg-config xlibsWrapper libdrm

    # add this:
    libglvnd libxkbcommon vulkan-headers libX11 libXcomposite

  ];
```

ideally, these dependencies should be propagated by qtbase

examples

* pkgs/development/libraries/qt-6/modules/qtwayland.nix

## failed to produce output path

full error:

```
FIXME warning: qt module has no plugins but "bin" output
todo: in qtModule for qtwebchannel-6.2.2, remove:
  outputs = [ "out" "dev" "bin" ];
verify that all _IMPORT_PREFIX are replaced ...
verify that all _IMPORT_PREFIX are replaced done
error: builder for '/nix/store/yrnkch6cfhq29zvjklhz2fv3jbicr5nh-qtwebchannel-6.2.2.drv' failed to produce output path for output 'bin'
```

solution: remove `bin` from outputs in qt-6/modules/qtwebchannel.nix

```diff
-  outputs = [ "out" "dev" "bin" ];
+  outputs = [ "out" "dev" ];
```

## optional packages have not been found

when cmake cannot find dependencies

example: `qt-6/modules/qtwebsockets.nix`

```
-- The following OPTIONAL packages have not been found:

 * Vulkan
 * PkgConfig
 * Qt6QmlCompilerPlus
```

ideally, most of the optional dependencies should be provided

for example `PkgConfig` -> add `pkg-config`.
pkg-config is used to find dependencies, but is usually not needed by qt6

`Vulkan` is for 3D vector graphics ("3d svg").
missing vulkan is fine, because `WrapVulkanHeaders` is found.

`Qt6QmlCompilerPlus`? no idea, but sounds important.

