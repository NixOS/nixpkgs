{ stdenv, fetchFromGitHub, haxe, hxcpp, hxcs, flixel, openfl, lime, luxe, pixijs, flambe, nme, hscript, installLibHaxe, simulateHaxelibDev, wxGTK30, mesa_noglu, libX11 }:

let
  meta = with stdenv.lib; {
    description = "Styleable application centric rich UI";
    homepage = http://haxeui.org;
    license = licenses.mit;
    platforms = platforms.linux; # might work on mac and windows too
  };
in rec {
  hxWidgets = let
    libname = "hxWidgets";
    version = "2017-05-23-unstable";
  in stdenv.mkDerivation rec {
    name = "${libname}-${version}";
    src = fetchFromGitHub {
      owner = "haxeui";
      repo = "hxWidgets";
      rev = "141ccde";
      sha256 = "0qg7ffzs6a00raw2rygh6zbws67wk4kflxin9mbyq7dgj4g8kwg6";
    };
    buildInputs = [ haxe hxcpp ];
    propagatedBuildInputs = [ (wxGTK30.override { withWebKit = true; }) mesa_noglu libX11 ];
    doCheck = true; # it compiles demo project
    checkPhase = ''
      ${simulateHaxelibDev libname}

      (cd samples/00-Showcase ; haxe build.hxml ; rm -rf bin/obj )
    '';
    installPhase = installLibHaxe { inherit libname version; };
    inherit meta;
  };

  haxeui-core = let
    libname = "haxeui-core";
    version = "2017-05-24-unstable";
  in stdenv.mkDerivation {
    name = "${libname}-${version}";
    src = fetchFromGitHub {
      owner = "haxeui";
      repo = "haxeui-core";
      rev = "ec20b7d";
      sha256 = "1z4ckfykpkdfdagg5lg11dygfsbr65pzxwvwdpa3xhnzq9n5ipqz";
    };
    propagatedBuildInputs = [ hscript ];
    installPhase = installLibHaxe { inherit libname version; };
    inherit meta;
  };

  haxeui-hxwidgets = let
    libname = "haxeui-hxwidgets";
    version = "2017-05-21-unstable";
  in stdenv.mkDerivation {
    name = "${libname}-${version}";
    src = fetchFromGitHub {
      owner = "haxeui";
      repo = "haxeui-hxwidgets";
      rev = "9f0aa7c";
      sha256 = "0qd3y4zddhgp0m6a9drwmcz455s1qyah7p1by680xinafh18wmdm";
    };
    buildInputs = [ haxe hxcpp ];
    propagatedBuildInputs = [ haxeui-core hxWidgets ];
    doCheck = true; # it compiles empty project
    checkPhase = ''
      ${simulateHaxelibDev libname}

      haxe linux.hxml ; rm -rf bin/{src,include,obj}
    '';
    installPhase = installLibHaxe { inherit libname version; };
    inherit meta;
  };

  haxeui-openfl = let
    libname = "haxeui-openfl";
    version = "2015-05-23-unstable";
  in stdenv.mkDerivation {
    name = "${libname}-${version}";
    src = fetchFromGitHub {
      owner = "haxeui";
      repo = "haxeui-openfl";
      rev = "2587400";
      sha256 = "0qm44yw2kk5049m6jq5xip6wggmdp6139ilry4hyjmcz6rqxb1wc";
    };
    buildInputs = [ haxe hxcpp ];
    propagatedBuildInputs = [ haxeui-core openfl ];
    doCheck = true; # compiles empty project
    checkPhase = ''
      ${simulateHaxelibDev libname}

      haxe linux.hxml ; rm -rf bin/openfl/linux64/cpp/obj/{src,include,obj}
    '';
    installPhase = installLibHaxe { inherit libname version; };
    inherit meta;
  };

  haxeui-flixel = let
    libname = "haxeui-flixel";
    version = "2017-05-24-unstable";
  in stdenv.mkDerivation {
    name = "${libname}-${version}";
    src = fetchFromGitHub {
      owner = "haxeui";
      repo = "haxeui-flixel";
      rev = "26df77b";
      sha256 = "153l6rk21lkl93h6fimrs4rclh080rl3x801sf0gcg0z63j664pr";
    };
    propagatedBuildInputs = [ haxeui-core flixel ];
    installPhase = installLibHaxe { inherit libname version; };
    inherit meta;
  };

  haxeui-luxe = let
    libname = "haxeui-luxe";
    version = "2017-03-28-unstable";
  in stdenv.mkDerivation {
    name = "${libname}-${version}";
    src = fetchFromGitHub {
      owner = "haxeui";
      repo = "haxeui-luxe";
      rev = "4104b47";
      sha256 = "0w58js8n6fdki8sbpwsid3k8x16sjss26krjnhhv3hbx2kmy14pv";
    };
    propagatedBuildInputs = [ haxeui-core luxe ];
    installPhase = installLibHaxe { inherit libname version; };
    inherit meta;
  };

  haxeui-pixijs = let
    libname = "haxeui-pixijs";
    version = "2017-04-29-unstable";
  in stdenv.mkDerivation {
    name = "${libname}-${version}";
    src = fetchFromGitHub {
      owner = "haxeui";
      repo = "haxeui-pixijs";
      rev = "1bc4558";
      sha256 = "01azrzdza5ij9x1cspsy88fjv8d7cczmq7sjar06919bsbv39wg3";
    };
    buildInputs = [ haxe ];
    propagatedBuildInputs = [ haxeui-core pixijs ];
    doCheck = true;
    checkPhase = ''
      ${simulateHaxelibDev libname}

      haxe build.hxml
    '';
    installPhase = installLibHaxe { inherit libname version; };
    inherit meta;
  };

  haxeui-flambe = let
    libname = "haxeui-flambe";
    version = "2017-04-29-unstable";
  in stdenv.mkDerivation {
    name = "${libname}-${version}";
    src = fetchFromGitHub {
      owner = "haxeui";
      repo = "haxeui-flambe";
      rev = "797e7f3";
      sha256 = "07h80zsnmcyqiyf91v6pbpfljsp38jwlmrfizrhs9qpyrnrlmkdw";
    };
    buildInputs = [ haxe ];
    propagatedBuildInputs = [ haxeui-core flambe ];
    doCheck = true;
    checkPhase = ''
      ${simulateHaxelibDev libname}

      haxe build.hxml
    '';
    installPhase = installLibHaxe { inherit libname version; };
    inherit meta;
  };

  haxeui-html5 = let
    libname = "haxeui-html5";
    version = "2017-04-29-unstable";
  in stdenv.mkDerivation {
    name = "${libname}-${version}";
    src = fetchFromGitHub {
      owner = "haxeui";
      repo = "haxeui-html5";
      rev = "36faffb";
      sha256 = "0h8nwn6c4iihx87hb7zgskwimd14p5dmxyszffcyw7y8fwxi3br7";
    };
    buildInputs = [ haxe ];
    propagatedBuildInputs = [ haxeui-core ];
    doCheck = true;
    checkPhase = ''
      ${simulateHaxelibDev libname}

      haxe build.hxml
    '';
    installPhase = installLibHaxe { inherit libname version; };
    inherit meta;
  };

  haxeui-nme = let
    libname = "haxeui-nme";
    version = "2017-05-23-unstable";
  in stdenv.mkDerivation {
    name = "${libname}-${version}";
    src = fetchFromGitHub {
      owner = "haxeui";
      repo = "haxeui-nme";
      rev = "6f69b90";
      sha256 = "1k02yqqgl480kncxnc794dnzg6ydh3kk8bzavjrfxhk21wi5fzs0";
    };
    buildInputs = [ haxe hxcpp ];
    propagatedBuildInputs = [ haxeui-core nme ];
    doCheck = true; # it compiles empty project
    checkPhase = ''
      ${simulateHaxelibDev libname}

      haxe linux.hxml ; rm -rf bin/nme/*/cpp/{src,include,obj}
    '';
    installPhase = installLibHaxe { inherit libname version; };
    inherit meta;
  };

  haxeui-kha = let
    libname = "haxeui-kha";
    version = "2017-04-29-unstable";
  in stdenv.mkDerivation {
    name = "${libname}-${version}";
    src = fetchFromGitHub {
      owner = "haxeui";
      repo = "haxeui-kha";
      rev = "c51eb80";
      sha256 = "0k0ip742cl19m8krwh2hnspaly4j3z5wz047swlbhs5f0rwc1jdp";
    };
    propagatedBuildInputs = [ haxeui-core /*kha*/ ];
    installPhase = installLibHaxe { inherit libname version; };
    inherit meta;
  };

  haxeui-xwt = let
    libname = "haxeui-xwt";
    version = "2017-05-21-unstable";
  in stdenv.mkDerivation {
    name = "${libname}-${version}";
    src = fetchFromGitHub {
      owner = "haxeui";
      repo = "haxeui-xwt";
      rev = "d1de5ea";
      sha256 = "05j1vi914mqplfc59k32qp7hhqyrjgfvan3n198h1hs5yvmcnygd";
    };
    buildInputs = [ haxe hxcs ];
    propagatedBuildInputs = [ haxeui-core ];
    installPhase = installLibHaxe { inherit libname version; };
    doCheck = true; # it compiles empty project
    checkPhase = ''
      ${simulateHaxelibDev libname}

      haxe test.hxml
     '';
    inherit meta;
  };

}