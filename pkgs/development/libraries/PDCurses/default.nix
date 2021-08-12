{ lib, stdenv
, fetchFromGitHub
, SDL, SDL2, xorg
, symlinkJoin
}:

let
  base = rec {
    version = "3.9";

    src = fetchFromGitHub {
      owner = "wmcbrine";
      repo = "PDCurses";
      rev = version;
      sha256="sha256-DNxIwNK6hsiZC+bjbmdUGEOkJM3/fEOEFJYZOUh/f0w=";
    };

    meta = with lib; {
      description = "PDCurses is an implentation of X/Open curses for multiple platforms";
      homepage = "https://pdcurses.org";
      license = licenses.publicDomain;
      maintainers = with maintainers; [ hqurve ];
    };

  };

  maker = name: {installPhase ? null, ...}@attrs:
    stdenv.mkDerivation ( base
    // {
      name = "PDCurses-${name}";
      sourceRoot = "source/${name}";
    }
    // attrs
    // lib.attrsets.optionalAttrs (installPhase != null){
      installPhase = ''
        runHook preInstall

        ${installPhase}

        runHook postInstall
      '';
    });


  platforms = {
    x11 = let
      packages = with xorg; [
          libXt
          libXt.dev
          libXaw3d
          libXmu
          libXmu.dev
          libX11
          libXpm.out
          libXpm.dev
          xorgproto.out
      ];
      x11Includes = symlinkJoin {
        name = "PDCurses-X11-includes";
        paths = packages;
      };
    in {
      nativeBuildInputs = packages;

      postPatch = ''
        # very bad way to get things to work
        # needs to be redone
        substituteInPlace configure \
          --replace "/usr/X11/include" "${x11Includes}/include/X11" \
          --replace "which dpkg" "echo "\
          --replace "multiarch_libdir=" "multiarch_libdir=\"${x11Includes}/lib\" #"

        substituteInPlace Makefile.in \
          --replace '$(includedir)/xcurses' '$(includedir)'
      '';

      configureFlags = [
        "--enable-widec"
        "--with-xaw3d"
        "--with-x"
      ];
      installFlags = [ "prefix=$(out)" ];

      postInstall = ''
        cp ../curspriv.h $out/include
        cp -r .. $out/cool
      '';
    };
    sdl1 = {
      nativeBuildInputs = [ SDL ];
      postBuild = ''
        gcc -shared -o pdcurses.so *.o
      '';
      installPhase = ''
        mkdir -p $out/include
        cp pdcsdl.h $out/include

        mkdir -p $out/lib
        cp pdcurses.so $out/lib/libpdcurses.so
      '';
    };
    sdl2 = {
      nativeBuildInputs = [ SDL2 ];
      postBuild = ''
        gcc -shared -o pdcurses.so *.o
      '';
      installPhase = ''
        mkdir -p $out/include
        cp pdcsdl.h $out/include

        mkdir -p $out/lib
        cp pdcurses.so $out/lib/libpdcurses.so
      '';
    };
  };
in
  lib.attrsets.mapAttrs maker platforms
