# the nix-python way..

# By default python looks in the $prefix/lib/python-$version/site-packages directory
# and reads the .pth files to add the library paths to sys.path. 
# Using PYHTONPATH is not enough because it doesn't make python read the .pth files
# telling python where to find additional modules. PYTHONUSERBASE would suffice, but
# it only supports *one* user location. That's why I've added the new env var NIX_PYTHON_SITES
# containing a colon separated list of modules telling python where to look
# for imports and also read the .pth files

p: # p = pkgs
let 
  inherit (p) lib fetchurl stdenv getConfig;
in
  lib.fix ( t : { # t = this attrs

    version = "2.5";
    versionAttr = "python25";

    # see pythonFull.
    pythonMinimal = ( (import ./python.nix) {
      name = "python-${t.version}";
      inherit (p) fetchurl stdenv lib bzip2 ncurses composableDerivation;
      inherit  (p) zlib sqlite db4 readline openssl gdbm;
    });

    # python wiht all features enabled.
    # if you really need a stripped version we should add __overides
    # so that you can replace it the way it's done in all-packages.nix
    pythonFull = t.pythonMinimal.passthru.fun {
     name = "python-${t.version}-full";
      cfg = {
        zlibSupport = true;
        sqliteSupport = true;
        db4Support = true;
        readlineSupport = true;
        opensslSupport = true;
        gdbmSupport = true;
      };
    };

    # python wrapper. You should install this
    # It automatically wrapps python adding NIX_PYTHON_SITES so that you can use all the libraries
    # when running the wrapper from the console.
    # configuration:
    # python25 = { wrapperLibs = let p = pkgs.python25New; in [ p.wxPython25 p.name p.name2 ]; }; 
    # python25 = { wrapperLibs = [ "all" ]; }; # install all libraries provided by this file
    # TODO: does pydoc find stuff from libraries?
    pythonWrapper = stdenv.mkDerivation {
      name = "${t.pythonFull.name}-wrapper";
      # [1] using full because I feel installing various versions isn't any better
      phases = "buildPhase";
      buildInputs = [ p.makeWrapper ] 
        ++ lib.concatMap (x: if x == "all" then t.all else [x]) (getConfig [t.versionAttr "wrapperLibs"] []);

      buildPhase = ''
        ensureDir $out/bin
        cat >> $out/bin/python << EOF
        export NIX_PYTHON_SITES=\$NIX_PYTHON_SITES:$NIX_PYTHON_SITES
        exec ${t.pythonFull}/bin/python "\$@"
        EOF
        chmod +x $out/bin/python
      '';
    };

    ### basic support for installing python libraries
    # set pyCheck to a small python snippet importing all modules of this python
    # lib to verify it works
    # You can define { python25 { debugCmd = "DISPLAY=:0.0 pathtoxterm"; }
    # in your config for easier debugging..
    pythonLibStub = p.composableDerivation {
      initial = {
          propagatedBuildInputs = [ t.pythonFull ]; # see [1]
          postPhases = ["postAll"]; # using new name so that you dno't override this phase by accident
          prePhases = ["defineValidatingEval"];
          # ensure phases are run or a non zero exit status is caused (if there are any syntax errors such as eval "while")
          defineValidatingEval = ''
            eval(){
              e="$(type eval | { read; while read line; do echo $line; done })"
              unset eval;
              local evalSucc="failure"
              eval "evalSucc=ok;""$1"
              eval "$e"
              [ $evalSucc = "failure" ] && { echo "eval failed, snippet:"; echo "$1"; return 1; }
            }
          '';
          postAll = ''
            ensureDir $out/nix-support
            echo "export NIX_PYTHON_SITES=\"$out:\$NIX_PYTHON_SITES\"" >> $out/nix-support/setup-hook 
            # run check
            [ -n "$pyCheck" ] \
              && ( . $out/nix-support/setup-hook
                   mkdir $TMP/new-test; cd $TMP/new-test
                   echo PYTHONPATH=$PYTHONPATH
                   echo NIX_PYTHON_SITES=$NIX_PYTHON_SITES
                   script="$(echo -e "import sys\nprint sys.path\npyCheck\nprint \"check ok\"")"
                   script="''${script/pyCheck/$pyCheck}"
                   echo "check script is"; echo "$script"
                   echo "$script" | /var/run/current-system/sw/bin/strace -o $TMP/strace -f python || { ${ getConfig [t.versionAttr "debugCmd"] ":"} ; exit 1; }
                   )'';
          passthru = {
            libPython = t.version; # used to find all python libraries fitting this version (-> see name all below)
          };
          mergeAttrBy = {
            postCheck = x : y : "${x}\n${y}";
          };
      };
    };

    # same as pythonLibStub, but runs default python setup.py actions
    pythonLibSetup = t.pythonLibStub.passthru.fun {
      buildPhase = ''python setup.py $setupFlags build'';
      installPhase = ''python setup.py $setupFlags install --prefix=$out'';
      mergeAttrBy = {
        setupFlags = lib.concatList;
      };
    };

    ### python libraries:

    wxPythonBaseFun = (t.pythonLibSetup.passthru.funMerge (a :
      let inherit (a.fixed) wxGTK version; in
        {
          buildInputs = [p.pkgconfig wxGTK (wxGTK.gtk)];
          setupFlags=["WXPORT=gtk2 NO_HEADERS=1 BUILD_GLCANVAS=0 BUILD_OGL=0 UNICODE=1"];
          configurePhase = ''cd wxPython'';
          pyCheck = "import wx";
          name = "wxPython-${version}";
          meta = { # 2.6.x and 2.8.x
            description="A blending of the wxWindows C++ class library with Python";
            homepage="http://www.wxpython.org/";
            license="wxWinLL-3";
          };
        }
    )).passthru.fun;

    wxPython26 = t.wxPythonBaseFun {
      version = "2.6.3.3";
      passthru = { wxGTK = p.wxGTK26; };
      src = fetchurl {
        url = mirror://sourceforge/wxpython/wxPython-src-2.6.3.3.tar.bz2;
        md5 = "66b9c5f8e20a9505c39dab1a1234daa9";
      };
    };

    # compilation errors
    #wxPython28 = t.wxPythonBaseFun {
    #  version = "2.8.9.1";
    #  passthru = { wxGTK = wxGTK28; };
    #  src = fetchurl {
    #    url = mirror://sourceforge.net/sourceforge/wxpython/wxPython-src-2.8.9.1.tar.bz2;
    #    sha256 = "1yp7l2c2lfpwc2x5lk5pawmzq2bqajzhbzqs1p10jd211slwhjsq";
    #  };
    #};

    # couldn't download source
    #foursuite = pythonLibSetup.passthru.fun {
    #  version = "1.0.2";
    #  name = "4suite-${version}";
    #  src = fetchurl {
    #    url = "mirror://sourceforge/foursuite/4Suite-XML-${version}.tar.bz2";
    #    sha256 = "0g5cyqxhhiqnvqk457k8sb97r18pwgx6gff18q5296xd3zf4cias";
    #  };
    #};

    #bsddb3 = t.pythonLibSetup.passthru.fun {
    #  version = "1.0.2";
    #  name = "bsddb3-4.5.0";
    #  setupFlags = ["--berkeley-db=${p.db4}"];
    #  src = fetchurl {
    #    url = mirror://sourceforge/pybsddb/bsddb3-4.5.0.tar.gz;
    #    sha256 = "1h09kij32iikr9racp5p7qrb4li2gf2hs0lyq6d312qarja4d45v";
    #  };
    #};

  pygobject = t.pythonLibStub.passthru.fun {
    name = "pygobject-2.15.4";
    flags = { libffi = { buildInputs = [p.libffi];}; };
    cfg = { libffi = true; };
    buildInputs = [ p.pkgconfig p.gtkLibs.glib];
    src = fetchurl {
      url = "http://ftp.gnome.org/pub/GNOME/sources/pygobject/2.15/pygobject-2.15.4.tar.bz2";
      sha256 = "19vxczy01xyss2f5aqf93al3jzrxn50srgzkl4w7ivdz50rnjin7";
    };
    pyCheck = "import gobject";
  };

  pygtkBaseFun = (t.pythonLibStub.passthru.funMerge (a :
    let inherit (a.fixed) glib gtk version; in {
      name = "pygtk-${version}";
      buildInputs = [p.pkgconfig glib gtk];
      propagatedBuildInputs = [t.pygobject t.pycairo ];
      flags = {
        cairo = { buildInputs = [ p.cairo ]; }; # TODO add pyCheck
        glade = { buildInputs = [ p.glade ]; }; # TODO add pyCheck
      };
      cfg = {
        glade = true;
        cairo = true;
      };
    }
  )).passthru.fun;

  #pygtk213 = t.pygtkBaseFun {
  #  version = "2.13.0";
  #  src = fetchurl {
  #    url = http://ftp.gnome.org/pub/GNOME/sources/pygtk/2.13/pygtk-2.13.0.tar.bz2;
  #    sha256 = "0644ll48hi8kwfng37b0k5qgb0fbiy298r7sxd4j7ag7lj4bgic0";
  #  };
  #  passthru = { inherit (p.gtkLibs) glib gitk; };
  #  pyCheck = ''
  #    import pygtk; pygtk.require('2.0')
  #    import gtk
  #  '';
  #};

  pygtk212 = t.pygtkBaseFun {
    version = "2.12.1";
    src = fetchurl {
      url = http://ftp.acc.umu.se/pub/GNOME/sources/pygtk/2.12/pygtk-2.12.1.tar.bz2;
      sha256 = "0gg13xgr7y9sppw8bdys042928nc66czn74g60333c4my95ys021";
    };
    passthru = { inherit (p.gtkLibs) glib gtk; };
    pyCheck = ''
      import pygtk; pygtk.require('2.0')
      import gtk
    '';
    patches = [ ./pygtk-2.12.1-fix-amd64-from-gentoo.patch ];
  };

  pycairo = t.pythonLibStub.passthru.fun {
    name = "pycairo-1.8.0";
    buildInputs = [ p.pkgconfig p.cairo p.x11 ];
    src = fetchurl {
      url = http://www.cairographics.org/releases/pycairo-1.6.4.tar.gz;
      md5 = "2c3aa21e6e610321498f9f81f7b625df";
    };
    pyCheck = "import cairo";
  };

  gstPython = t.pythonLibStub.passthru.fun {
    name = "gst-python-0.10.13";
    src = fetchurl {
      url = http://gstreamer.freedesktop.org/src/gst-python/gst-python-0.10.13.tar.gz;
      sha256 = "0yin36acr5ryfpmhlb4rlagabgxrjcmbpizwrc8csadmxzmigb86";
    };
    buildInputs =[ p.flex2535 p.pkgconfig];
    propagatedBuildInputs = [
          t.pygtk212
          p.gst_all.gstreamer
          p.gst_all.gstPluginsBase
          p.gst_all.gstPluginsGood
        ];
    pyCheck = ''
      import pygst
      pygst.require('0.10')
      import gst
    '';
    meta = {
      description = "python gstreamer bindings";
      homepage = http://gstreamer.freedesktop.org/modules/gst-python.html;
      license = "GPLv2.1";
    };
  };

  ### python applications

  pythonExStub = p.composableDerivation {
    initial = {
      buildInputs = [p.makeWrapper];
      postPhases = ["wrapExecutables"];
      propagatedBuildInputs = [ t.pythonFull ]; # see [1]
      wrapExecutables = ''
        for prog in $out/bin/*; do
        wrapProgram "$prog"     \
                     --set NIX_PYTHON_SITES "$NIX_PYTHON_SITES"
        done
      '';
    };
  };

  pitivi = t.pythonExStub.passthru.fun {
    name = "pitivi-0.11.2";
    src = fetchurl {
      url = http://ftp.gnome.org/pub/GNOME/sources/pitivi/0.11/pitivi-0.11.2.tar.bz2;
      sha256 = "0d3bqgfp60qm5bf904k477bd8jhxizj1klv84wbxsz9vhjwx9zcl";
    };
    buildInputs =[ t.pygtk212 t.gstPython p.intltool p.gettext p.makeWrapper p.gettext ];
    # why do have to add gtk-2.0 explicitely?
    meta = {
        description = "A non-linear video editor using the GStreamer multimedia framework";
        homepage = http://www.pitivi.org/wiki/Downloads;
        license = "LGPL-2.1";
    };
    postInstall = ''
      # set the python which has been used to compile this package
      sed -i -e 's@#!.*@#!'"$(which python)@" $out/bin/pitivi
    '';
  };

  all = lib.filter (x: 
                   (__isAttrs x)
                && ((lib.maybeAttr "libPython" false x) == t.version)
                && (lib.maybeAttr "name" false x != false) # don't collect pythonLibStub etc
        ) (lib.flattenAttrs (removeAttrs t ["all"])); # nix is not yet lazy enough, so I've to remove all first
})
