{ stdenv, fetchFromGitHub, fetchgit, bash, nodejs, haxe, neko, hxcpp, openal, mesa_glu, libX11, libXext, libXinerama, libXrandr, installLibHaxe, simulateHaxelibDev }:

let
  meta = with stdenv.lib; {
    description = "Low level cross platform framework";
    homepage = http://snowkit.org;
    license = licenses.mit;
    platforms = platforms.linux; # might work on mac and windows too
  };
in rec {
  flow = let
    libname = "flow";
    version = "2017-05-04-unstable";
  in stdenv.mkDerivation rec {
    name = "${libname}-${version}";
    src = fetchFromGitHub {
      owner = "snowkit";
      repo = "flow";
      rev = "16bc999";
      sha256 = "19zcds93i6v6p92nzkvcx5df8342x47mb635iczidzjwig21n1wv";
    };
    propagatedBuildInputs = [ hxcpp ];
    buildInputs = [ haxe neko ];
    buildPhase = ''
      substituteInPlace src/Flow.hx --replace 'Sys.command(node_path' 'Sys.command("${nodejs}/bin/node"'
      (cd src; haxe compile.hxml)
    '';
    installPhase = installLibHaxe { inherit libname version; files = "src flow.png haxelib.json LICENSE.md readme.md run.n"; };
    postFixup = ''
      mkdir -p $out/bin
      cat > $out/bin/flow <<EOF
      #!${bash}/bin/bash

      export HAXELIB_PATH="\$HAXELIB_PATH\''${HAXELIB_PATH:+:}$HAXELIB_PATH:$out/lib/haxe"
      export PATH="\$PATH:${haxe}/bin:${neko}/bin"
      exec haxelib run flow "\$@"
      EOF
      chmod +x $out/bin/flow
    '';
    inherit meta;
  };

  linc_openal = let
    libname = "linc_openal";
    version = "2017-02-13-unstable";
  in stdenv.mkDerivation rec {
    name = "${libname}-${version}";
    src = fetchFromGitHub {
      owner = "snowkit";
      repo = "linc_openal";
      rev = "8231209";
      sha256 = "0pwfv4lz2p1802a4dr9jrqns5gdvnfailj3y75vvllmsdn4309vc";
    };
    propagatedBuildInputs = [ openal ];
    buildInputs = [ haxe hxcpp ];
    buildPhase = ''
      substituteInPlace linc/linc_openal.h --replace '#include <hxcpp.h>' ""
    '';
    doCheck = false; # fails with "Failed to create /homeless-shelter/.config/pulse"
    checkPhase = ''
      (cd test; haxe -main Test.hx -resource sound.pcm@sound.pcm -cpp cpp/ -cp ../ -D linux && ./cpp/Test && rm -rf cpp)
    '';
    installPhase = installLibHaxe { inherit libname version; };
    inherit meta;
  };

  linc_timestamp = let
    libname = "linc_timestamp";
    version = "2017-02-01-unstable";
  in stdenv.mkDerivation rec {
    name = "${libname}-${version}";
    src = fetchFromGitHub {
      owner = "snowkit";
      repo = "linc_timestamp";
      rev = "37c4285";
      sha256 = "1awax5gvrlbas7m7i8im4iyd8hdnjz7hyc488ysp9ccnvxjrcjwk";
    };
    buildInputs = [ haxe hxcpp ];
    doCheck = true;
    checkPhase = ''
      ( cd test && haxe -main Test.hx -cpp cpp/ -cp ../ -debug -D linux && cpp/Test-debug && rm -rf cpp )
    '';
    installPhase = installLibHaxe { inherit libname version; };
    inherit meta;
  };

  linc_stb = let
    libname = "linc_stb";
    version = "2017-02-01-unstable";
  in stdenv.mkDerivation rec {
    name = "${libname}-${version}";
    src = fetchFromGitHub {
      owner = "snowkit";
      repo = "linc_stb";
      rev = "5a9f8fe";
      sha256 = "0nscnh3x09nkymn7i0a48jpkg7s17sj5ybxqqwypckv2k2xbmvlh";
    };
    buildInputs = [ haxe hxcpp ];
    buildPhase = ''
      substituteInPlace linc/linc_stb_image.h       --replace '#include <hxcpp.h>' ""
      substituteInPlace linc/linc_stb_image_write.h --replace '#include <hxcpp.h>' ""
      substituteInPlace linc/linc_stb_truetype.h    --replace '#include <hxcpp.h>' ""
    '';
    doCheck = true;
    checkPhase = ''
      ( cd tests/Image      && haxe -main Test.hx -resource image.png@image.png -cpp cpp/ -cp ../../ -debug -D linux && cpp/Test-debug && rm -rf cpp )
      ( cd tests/ImageWrite && haxe -main Test.hx                               -cpp cpp/ -cp ../../ -debug -D linux && cpp/Test-debug && rm -rf cpp )
      #(cd tests/TrueType   && haxe -main Test.hx                               -cpp cpp/ -cp ../../ -debug -D linux && cpp/Test-debug && rm -rf cpp )
    '';
    installPhase = installLibHaxe { inherit libname version; };
    inherit meta;
  };

  linc_ogg = let
    libname = "linc_ogg";
    version = "2017-02-13-unstable";
  in stdenv.mkDerivation rec {
    name = "${libname}-${version}";
    src = fetchgit {
      url = https://github.com/snowkit/linc_ogg.git;
      rev = "92ebeb9";
      fetchSubmodules = true; # lib/ogg lib/vorbis lib/theora
      sha256 = "15w5fsmcg5ffk0frrynq0hqmdq07863knkg87i0jw6bb02iwg31w";
    };
    buildInputs = [ haxe hxcpp ];
    buildPhase = ''
      substituteInPlace linc/linc_ogg.h --replace '#include <hxcpp.h>' ""
    '';
    doCheck = true;
    checkPhase = ''
      ( cd test && haxe -main Test.hx -cpp cpp/ -cp ../ -debug -D linux && cpp/Test-debug && rm -rf cpp )
    '';
    installPhase = installLibHaxe { inherit libname version; };
    inherit meta;
  };

  linc_sdl = let
    libname = "linc_sdl";
    version = "2017-02-13-unstable";
  in stdenv.mkDerivation rec {
    name = "${libname}-${version}";
    src = fetchgit {
      url = https://github.com/snowkit/linc_sdl.git;
      rev = "622c44d";
      fetchSubmodules = true; # lib/sdl
      sha256 = "1n6z783rkam4bg4glj6b84ia8bsaqrh2mim3a8fznqf799d2asas";
    };
    propagatedBuildInputs = [ mesa_glu libX11 libXext libXinerama libXrandr ];
    buildInputs = [ haxe hxcpp ];
    buildPhase = ''
      substituteInPlace linc/linc_sdl.h --replace '#include <hxcpp.h>' ""
    '';
    doCheck = false; # the test fails on my machine
    checkPhase = ''
      ( cd test && haxe -main Test.hx -cpp cpp/ -cp ../ -debug -D linux && cpp/Test-debug && rm -rf cpp )
    '';
    installPhase = installLibHaxe { inherit libname version; };
    inherit meta;
  };

  linc_opengl = let
    libname = "linc_opengl";
    version = "2017-02-13-unstable";
  in stdenv.mkDerivation rec {
    name = "${libname}-${version}";
    src = fetchgit {
      url = https://github.com/snowkit/linc_opengl.git;
      rev = "21c1dfd";
      fetchSubmodules = true; # lib/glew
      sha256 = "1iy3c12qh31wa6yms7wixl1pya890i1b8psi6vqcvy7xfvvm3dhw";
    };
    buildInputs = [ haxe hxcpp ];
    buildPhase = ''
      substituteInPlace linc/linc_opengl.h --replace '#include <hxcpp.h>' ""
    '';
    installPhase = installLibHaxe { inherit libname version; };
    inherit meta;
  };

  snow = let
    libname = "snow";
    version = "2017-05-24-unstable";
  in stdenv.mkDerivation rec {
    name = "${libname}-${version}";
    src = fetchFromGitHub {
      owner = "snowkit";
      repo = "snow";
      rev = "b933401";
      sha256 = "131vgbzhrah5qy4zbn923x7aa2priwiygl1p38ncscz267mrfmf8";
    };
    propagatedBuildInputs = [ linc_openal linc_timestamp linc_stb linc_ogg linc_sdl linc_opengl ];
    buildInputs = [ haxe neko flow ];
    doCheck = false; # too slow
    checkPhase = ''
      ${simulateHaxelibDev "snow"}
      (cd samples/basic               ; flow build ; rm -rf bin/*.build)
      (cd samples/audio               ; flow build ; rm -rf bin/*.build)
      (cd samples/window              ; flow build ; rm -rf bin/*.build)
      (cd samples/empty               ; flow build ; rm -rf bin/*.build)
      (cd samples/config              ; flow build ; rm -rf bin/*.build)
      (cd samples/audio_custom_stream ; flow build ; rm -rf bin/*.build)
      (cd samples/assets              ; flow build ; rm -rf bin/*.build)
    '';
    installPhase = installLibHaxe { inherit libname version; };
    inherit meta;
  };

  luxe = let
    libname = "luxe";
    version = "2017-04-18-unstable";
  in stdenv.mkDerivation rec {
    name = "${libname}-${version}";
    src = fetchFromGitHub {
      owner = "underscorediscovery";
      repo = "luxe";
      rev = "7345f6f";
      sha256 = "1yi4x4q9wns4gnvckw54h5yddr6xm3cqdxby1vkymrhm9d45mc66";
    };
    buildInputs = [ haxe neko flow snow ];
    doCheck = false; # too slow
    checkPhase = ''
      ${simulateHaxelibDev "luxe"}

      (cd samples/empty                      ; flow build ; rm -rf bin/*.build)
      (cd samples/examples/platformer        ; flow build ; rm -rf bin/*.build)
      (cd samples/alphas/1_0_parrott         ; flow build ; rm -rf bin/*.build)
      (cd samples/alphas/2_0_0010            ; flow build ; rm -rf bin/*.build)
      (cd samples/alphas/3_0_powell          ; flow build ; rm -rf bin/*.build)
      (cd samples/guides/1_getting_started   ; flow build ; rm -rf bin/*.build)
      (cd samples/guides/2_sprites           ; flow build ; rm -rf bin/*.build)
      (cd samples/guides/3_sprite_animation  ; flow build ; rm -rf bin/*.build)
      (cd samples/guides/4_text_and_tweening ; flow build ; rm -rf bin/*.build)
      (cd samples/guides/5_components        ; flow build ; rm -rf bin/*.build)
    '';
    installPhase = installLibHaxe { inherit libname version; };
    inherit meta;
  };
}