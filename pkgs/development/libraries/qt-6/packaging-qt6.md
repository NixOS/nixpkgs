qt is a huge library,
so here are some hints to help with packaging of qt6

see also

* https://nixos.wiki/wiki/Qt

## build times

maybe consider remote building ...

on a slow computer, qt will take days to compile.

estimates for a 2x2GHz cpu:

```
15 hours  qtwebengine
 2 hours  qtdeclarative
 2 hours  qtbase
```

## configure qt6

enable qt6 features, disable qt6 features

enabled features should produce a `yes` in the `Configure summary`, for example

```
Configure summary:

WebEngine Repository Build Options:
  Build Ninja ............................ no
  Build Gn ............................... yes
  Jumbo Build ............................ yes
  Developer build ........................ no
...
```

when the summary says `no`,
either dependencies are missing,
or the feature is disabled by default.

qt5 used `configure`. for example `./configure -system-ffmpeg`

qt6 uses cmake, so we need

```nix
{
  cmakeFlags = [
    "-DQT_FEATURE_webengine_system_ffmpeg=ON"
  ];
}
```

to enable `webengine-system-ffmpeg` in `qtwebengine-everywhere-src-6.2.2/configure.cmake`

```cmake
qt_feature("webengine-system-ffmpeg" PRIVATE
    LABEL "ffmpeg"
    AUTODETECT FALSE
    CONDITION FFMPEG_FOUND AND QT_FEATURE_webengine_system_opus AND QT_FEATURE_webengine_system_libwebp
)
```

list all features as cmake flags

```sh
cd $(mktemp -d)

tar xf /nix/store/*-qtbase-everywhere-src-6.2.2.tar.xz

find . -name configure.cmake | xargs cat \
  | grep ^qt_feature | cut -d'"' -f2 \
  | sed 's/-/_/g; s/^.*$/    "-DQT_FEATURE_&=ON"/' \
  | sort | uniq | tee all-features.txt

cat all-features.txt | grep -i sqlite
    "-DQT_FEATURE_sql_sqlite=ON"
    "-DQT_FEATURE_system_sqlite=ON"
```

## system libraries

builds should use "system" versions of libraries where possible,
to reduce build time (and disk space).

otherwise, the libraries are compiled from source,
and statically linked into qt.

## splitBuildInstall

useful to modify post install phases, without recompiling (buildPhase)

problem: not working with ninja, requires cmake.
ninja makes it much harder to patch build files between buildPhase and installPhase.

alternative: impure build + ccache

works for:

* qtbase
* qtdeclarative

## debugging cmake

```nix
  cmakeFlags = [ "--trace-expand" ];
```

this is really verbose. better write a logfile:

```
nix-build . -A qt6.qtdeclarative 2>&1 | tee build.log
```

## splitBuildInstall

useful to fix a broken `installPhase` or `fixupPhase`.

with `qtModule`'s `splitBuildInstall`,
the "rebuild" of qtdeclarative takes only about 2 minutes,
compared to 150 minutes for a full rebuild (2x2GHz cpu).

when the `buildPhase` is done,
its result is cached.

as long we modify only the `splitBuildInstall` attriute,
the cached `buildPhase` stays valid.

to enable `splitBuildInstall`,
modify the `qtModule` call:

```nix
qtModule {
  pname = "some-module";
  #splitBuildInstall = {}; # minimal version
  splitBuildInstall = {
    postFixup = ''
      # copy-paste postFixup from qtModule
      # fix the postFixup phase
      # add fixes to the qtModule's postFixup
    # ...
    '';
  };
  postFixup = ''
    # add this when splitBuildInstall is working
    # ...
  '';
}
```

## Failed to find Qt component "Quick"

fixed by adding `qtdeclarative` to `qtInputs` or `propagatedBuildInputs`.

`qtModule`'s `setupHook` will add `qtdeclarative` to `QT_ADDITIONAL_PACKAGES_PREFIX_PATH`,
so that cmake can find `qtdeclarative`'s `$dev/lib/cmake`
