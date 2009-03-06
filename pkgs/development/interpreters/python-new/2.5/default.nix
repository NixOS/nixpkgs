# the nix-python way..

# By default python looks in the $prefix/lib/python-$version/site-packages directory
# and reads the .pth files to add the library paths to sys.path. 
# Using PYHTONPATH is not enough because it doesn't make python read the .pth files
# telling python where to find additional modules. PYTHONUSERBASE would suffice, but
# it only supports *one* user location. That's why I've added the new env var NIX_PYTHON_SITES
# containing a colon separated list of modules telling python where to look
# for imports and also read the .pth files

# TODO optimize py modules automatically (gentoo has a ebuild function called python_mod_optimize ?)

p: # p = pkgs
let 
  inherit (p) lib fetchurl stdenv getConfig;
  inherit (p.composableDerivation) composableDerivation;
  # withName prevents  nix-env -qa \* from aborting (pythonLibStub is a derivation but hasn't a name)
  withName = lib.mapAttrs (n : v : if (__isAttrs v && (!__hasAttr "name" v)) then null else v);
in
  withName ( lib.fix ( t : { # t = this attrs

    version = "2.5";
    versionAttr = "python25";

    # see pythonFull.
    pythonMinimal = ( (import ./python.nix) {
      name = "python-${t.version}";
      inherit composableDerivation;
      inherit (p) fetchurl stdenv lib bzip2 ncurses;
      inherit  (p) zlib sqlite db4 readline openssl gdbm;
    });

    # python wiht all features enabled.
    # if you really need a stripped version we should add __overides
    # so that you can replace it the way it's done in all-packages.nix
    pythonFull = t.pythonMinimal.merge {
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

        for prog in python pydoc; do
          echo ========= prog $prog
          cat >> $out/bin/$prog << EOF
          export NIX_PYTHON_SITES=\$NIX_PYTHON_SITES:$NIX_PYTHON_SITES
          exec ${t.pythonFull}/bin/$prog "\$@"
        EOF
          echo chmod +x
          chmod +x $out/bin/$prog
        done
      '';
    };

    ### basic support for installing python libraries
    # set pyCheck to a small python snippet importing all modules of this python
    # lib to verify it works
    # You can define { python25 { debugCmd = "DISPLAY=:0.0 pathtoxterm"; }
    # in your config for easier debugging..
    pythonLibStub = composableDerivation {} {
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
          if [ -n "$pyCheck" ]; then
             ( . $out/nix-support/setup-hook
                 mkdir $TMP/new-test; cd $TMP/new-test
                 echo PYTHONPATH=$PYTHONPATH
                 echo NIX_PYTHON_SITES=$NIX_PYTHON_SITES
                 script="$(echo -e "import sys\nprint sys.path\npyCheck\nprint \"check ok\"")"
                 script="''${script/pyCheck/$pyCheck}"
                 echo "check script is"; echo "$script"
                 echo "$script" | python || { ${ getConfig [t.versionAttr "debugCmd"] ":"} ; echo "pycheck failed"; exit 1; }
             )
           fi'';
        passthru = {
          libPython = t.version; # used to find all python libraries fitting this version (-> see name all below)
        };
        mergeAttrBy = {
          pyCheck = x : y : "${x}\n${y}";
        };
    };

    # same as pythonLibStub, but runs default python setup.py actions
    pythonLibSetup = t.pythonLibStub.merge {
      buildPhase = ''python setup.py $setupFlags build'';
      installPhase = ''python setup.py $setupFlags install --prefix=$out'';
      mergeAttrBy = {
        setupFlags = lib.concat;
      };
    };

    ### python libraries:

    wxPythonBaseFun = (t.pythonLibSetup.merge (a :
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
    )).merge;

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
    #foursuite = pythonLibSetup.merge {
    #  version = "1.0.2";
    #  name = "4suite-${version}";
    #  src = fetchurl {
    #    url = "mirror://sourceforge/foursuite/4Suite-XML-${version}.tar.bz2";
    #    sha256 = "0g5cyqxhhiqnvqk457k8sb97r18pwgx6gff18q5296xd3zf4cias";
    #  };
    #};

    #bsddb3 = t.pythonLibSetup.merge {
    #  version = "1.0.2";
    #  name = "bsddb3-4.5.0";
    #  setupFlags = ["--berkeley-db=${p.db4}"];
    #  src = fetchurl {
    #    url = mirror://sourceforge/pybsddb/bsddb3-4.5.0.tar.gz;
    #    sha256 = "1h09kij32iikr9racp5p7qrb4li2gf2hs0lyq6d312qarja4d45v";
    #  };
    #};

  # pyglib contains import reference to pygtk! So its best to install both at
  # the same time. I don't want to patch this.
  # You can install both into different store paths, however you won't be able
  # to import gtk because after pygtk.require sys.path contains to 
  # /nix/store/*-pygobject/**/gtk-2.0 (should be pygtk/**/gtk-2.0 instead)

  # gnome python is added here as well because it is loaded after
  # pygtk.require('2.0') as well. So the pygtk lib path is added to sys.path only.
  # We could make extra derivations for that. But on the other hand that would require
  # patching pygtk to another */gtk2.0 directory to sys.path for each NIX_PYTHON_SITES.
  # If you install dozens of python packages this might be bloat.
  # So  I think the overhead of installing these packages into the same store path should be prefered.
  pygtkBaseFun = (t.pythonLibStub.merge (a :
    let inherit (a.fixed) glib gtk; in lib.mergeAttrsByFuncDefaults [
    {
      unpackPhase = "true";
      configurePhase = "true";
      patchPhase = "true";
      buildPhase = "true";
      installPhase = ''
        unset unpackPhase
        unset configurePhase
        unset buildPhase
        unset installPhase
        export G2CONF="--enable-gconf" # hack, should be specified somewhere else
        for srcs in $pygobjectSrc $pygtkSrc $pySrcs; do
          cd $TMP; mkdir "$(basename $srcs)"; cd "$(basename $srcs)"; unpackPhase
          cd $sourceRoot
          configurePhase; buildPhase; installPhase
            addToEnv $out # pygtk has to know about pygobject
            PATH=$out/bin:$PATH # gnome-python nees pygtk-codegen
        done
      '';
      mergeAttrBy = {
        phases = lib.concat;
        pySrcs = lib.concat;
        pyCheck = x : y : "${x}\n${y}";
      };
    }
    # pygobject
    {
      flags = {
        libffi = { buildInputs = [p.libffi];};
      };
      cfg = {
        libffiSupport = true;
      };
      pyCheck = "import gobject";
      passthru = {
        pygobjectVersion = "2.15.4";
      };
      pygobjectSrc = fetchurl {
        url = "http://ftp.gnome.org/pub/GNOME/sources/pygobject/2.15/pygobject-2.15.4.tar.bz2";
        sha256 = "19vxczy01xyss2f5aqf93al3jzrxn50srgzkl4w7ivdz50rnjin7";
      };
      buildInputs = [ p.glibc ]; # requires ld-config

      propagatedBuildInputs = [ p.pkgconfig glib gtk ];
    }
    # pygtk
    {
      propagatedBuildInputs = [ t.pycairo ];
      flags = {
        cairo = {
          propagatedBuildInputs = [ p.cairo ];
          pyCheck = "import cairo";
        }; # TODO add pyCheck
        glade = {
          propagatedBuildInputs = [ p.gnome.libglade ];
          pyCheck = "from gtk import glade";
        };
      };
      pyCheck = ''
        import pygtk; pygtk.require('2.0')
        import gtk
        import gconf
      '';
      cfg = {
        gladeSupport = true;
        cairoSupport = true;
      };
    }
    # gnome-python
    {
      #name = "gnome-python-2.22.3";
      buildInputs = [ p.pkgconfig  p.gnome.libgnome ];
      propagatedBuildInputs = [ p.gnome.GConf ];
      pySrcs = [(fetchurl {
        url = http://ftp.gnome.org/pub/GNOME/sources/gnome-python/2.22/gnome-python-2.22.3.tar.bz2;
        sha256 = "0ndm3cns9381mm6d8jxxfd931fk93nqfcszy38p1bz501bs3wxm1";
      })];
    }
    # gnome-desktop or gnome-python-extras desktop containing egg.trayicon needed by istanbul
    {
      # name = "gnome-desktop-2.24.0";
      buildInputs = [ p.pkgconfig ];
      propagatedBuildInputs = [ p.gnome.GConf ];
      pySrcs = [(fetchurl {
        url = http://ftp.gnome.org/pub/GNOME/sources/gnome-python-desktop/2.24/gnome-python-desktop-2.24.0.tar.bz2;
        sha256 = "16514gmv42ygjh5ggzsis697m73pgg7ydz11h487932kkzv4mmlg";
      })];
      pyCheck = "import egg.trayicon";
    }
    {
      # name = "gnome-python-extras-2.13";
      buildInputs = [ p.pkgconfig ];
      propagatedBuildInputs = [ p.gnome.GConf ];
      pySrcs = [(fetchurl {
        url = http://ftp.gnome.org/pub/GNOME/sources/gnome-python-extras/2.13/gnome-python-extras-2.13.3.tar.gz;
        sha256 = "0vj0289snagrnvbmrs1camwmrc93xgpw650iavj6mq7a3wqcra0b";
      })];
    }
  ]));

  #pygtk213 = t.pygtkBaseFun {
  #  version = "2.13.0";
  #  pygtkSrc = fetchurl {
  #    url = http://ftp.gnome.org/pub/GNOME/sources/pygtk/2.13/pygtk-2.13.0.tar.bz2;
  #    sha256 = "0644ll48hi8kwfng37b0k5qgb0fbiy298r7sxd4j7ag7lj4bgic0";
  #  };
  #  passthru = { inherit (p.gtkLibs) glib gitk; };
  #  pyCheck = ''
  #    import pygtk; pygtk.require('2.0')
  #    import gtk
  #  '';
  #};

  pygtk212 = t.pygtkBaseFun.merge (a : {
    version = "2.12.1";
    name = "pygobject-${a.fixed.pygobjectVersion}-and-pygtk-${a.fixed.version}";
    pygtkSrc = fetchurl { 
      url = http://ftp.acc.umu.se/pub/GNOME/sources/pygtk/2.12/pygtk-2.12.1.tar.bz2;
      sha256 = "0gg13xgr7y9sppw8bdys042928nc66czn74g60333c4my95ys021";
    };
    passthru = { inherit (p.gtkLibs) glib gtk; };
    pyCheck = ''
      import pygtk; pygtk.require('2.0')
      import gtk
    '';
  });

  pycairo = t.pythonLibStub.merge {
    name = "pycairo-1.8.0";
    buildInputs = [ p.pkgconfig p.cairo p.x11 ];
    src = fetchurl {
      url = http://www.cairographics.org/releases/pycairo-1.6.4.tar.gz;
      md5 = "2c3aa21e6e610321498f9f81f7b625df";
    };
    pyCheck = "import cairo";
  };

  gstPython = t.pythonLibStub.merge {
    name = "gst-python-0.10.13";
    src = fetchurl {
      url = http://gstreamer.freedesktop.org/src/gst-python/gst-python-0.10.13.tar.gz;
      sha256 = "0yin36acr5ryfpmhlb4rlagabgxrjcmbpizwrc8csadmxzmigb86";
    };
    buildInputs =[ p.flex2535 p.pkgconfig];
    flags = {
      pluginsGood = { propagatedBuildInputs = [p.gst_all.gstPluginsGood]; };
      ffmpeg = { propagatedBuildInputs = [p.gst_all.gstFfmpeg]; };
    };
    cfg = {
      pluginsGoodSupport = true;
      ffmpegSupport = true;
    };
    propagatedBuildInputs = [
          t.pygtk212
          p.gst_all.gstreamer
          p.gst_all.gstPluginsBase
          p.gst_all.gnonlin
        ];
    # this check fails while building: It succeeds running as normal user
    /*
    Traceback (most recent call last):
      File "<stdin>", line 5, in <module>
      File "/nix/store/hnc51h035phlk68i1qmr5a8kc73dfvhp-gst-python-0.10.13/lib/python2.5/site-packages/gst-0.10/gst/__init__.py", line 170, in <module>
        from _gst import *
    RuntimeError: can't initialize module gst: Error re-scanning registry , child terminated by signal
    */
    pyCheck = ''
      #import pygst
      #pygst.require('0.10')
      #import gst
    '';
    meta = {
      description = "python gstreamer bindings";
      homepage = http://gstreamer.freedesktop.org/modules/gst-python.html;
      license = "GPLv2.1";
    };
  };

  pygoocanvas = t.pythonLibStub.merge {
    src = p.fetchurl {
      url = http://download.berlios.de/pygoocanvas/pygoocanvas-0.10.0.tar.gz;
      sha256 = "0pxznzdscbhvn8102vrqy3r1g6ss4sgs8wwy6y4c5g26rrp7l55d";
    };
    propagatedBuildInputs = [ t.pygtk212 ];
    buildInputs = [ p.pkgconfig p.goocanvas ];
    pyCheck = "import goocanvas";
    name = "pygoocanvas-0.10.0";
    meta = {
      description = "";
      homepage = http://developer.berlios.de/projects/pygoocanvas/;
      license = "LGPL";
    };
  };

#  zope = t.pythonLibStub.merge rec {
#[> version = "3.3.1";
#    version = "svn";
#    name = "zope-${version}";
#    [>src = p.blending.sourceByName "zope";
#    src = "/home/marc/managed_repos/zope";

#    [>fetchurl {
#    [> Doh! Python version 2.4.3 before continuing. Versions
#    [> 2.4.7 2.4.6 2.4.5 2.4.4 2.4.2 2.4.1 also work, but not as optimally.
#    [>  url = "http://www.zope.org/Products/Zope3/${version}/Zope-${version}.tgz";
#    [>  sha256 = "1qvvh384j7blzhwgfmd5kqvr5vzpv5khaj8ha46ln3hrwffrk2b1";
#    [>};
#    pyCheck = "";
#  };

  setuptools = t.pythonLibSetup.merge {
    name = "setuptools-0.6c9";
    postUnpack = ''
      ensureDir $out/lib/python2.5/site-packages
      export PYTHONPATH="$out/lib/python${t.version}/site-packages" # shut up installation script

      # setuptools tries to write to the installation location, so ensure it exists
      # and it requires PYTHONPATH to be set to that location (maybe its better to patch it. - I'm lazy)
      ensureDir $out/nix-support
      cat >> $out/nix-support/setup-hook << EOF
      ensureDir \$out/lib/python${t.version}/site-packages
      export PYTHONPATH="\$out/lib/python${t.version}/site-packages" # shut up installation script
      EOF
    '';
    src = p.fetchurl {
      url = "http://pypi.python.org/packages/source/s/setuptools/setuptools-0.6c9.tar.gz";
      md5 = "3864c01d9c719c8924c455714492295e";
    };
  };

  zopeInterface = t.pythonLibSetup.merge rec {
    version = "3.3.0";
    name = "zope.interface-${version}";
    buildInputs = [ t.setuptools ];
    src = p.fetchurl {
      url = "http://www.zope.org/Products/ZopeInterface/3.3.0/zope.interface-${version}.tar.gz";
      sha256 = "0xahg9cmagn4j3dbifvgzbjliw2jdrbf27fhqwkdp8j80xpyyjf0";
    };
    pyCheck = "from zope.interface import Interface, Attribute";
  };

  dbusPython = t.pythonLibStub.merge rec {
    version = "0.83.0";
    name = "dbus-python-0.83.0";
    buildInputs = [ p.pkgconfig ];
    propagatedBuildInputs = [ p.dbus p.dbus_glib ];
    src = fetchurl {
      url = "http://dbus.freedesktop.org/releases/dbus-python/dbus-python-0.83.0.tar.gz";
      sha256 = "14b1fwq9jyvg9qbbrmpk1264s9shm9n638hsgmkh9fn2lmd1vpc9";
    };
    pyCheck = "import dbus";
    meta = { 
      description = "";
      homepage = http://freedesktop.org/wiki/Software/DBusBindings;
      license = [ "GPLv2" "AFL-2.1" ];
    };
  };

  pythonXlib = t.pythonLibSetup.merge {
    name = "python-xlib-0.14";
    src = fetchurl {
      url = http://puzzle.dl.sourceforge.net/sourceforge/python-xlib/python-xlib-0.14.tar.gz;
      sha256 = "1sv0447j0rx8cgs3jhjl695p5pv13ihglcjlrrz1kq05lsvb0wa7";
    };
    meta = {
      description = "tries to be a fully functional X client library beeing entirely written in python";
      license = [ "GPL" ];
      homepage = http://python-xlib.sourceforge.net/;
    };
  };

  mechanize = t.pythonLibSetup.merge {
    name = "mechanize-0.1.11";
    buildInputs = [ t.setuptools ];
    src = fetchurl {
      url = http://wwwsearch.sourceforge.net/mechanize/src/mechanize-0.1.11.tar.gz;
      sha256 = "1h62mwy4iz09jqz17nrb9j8y0djd500zdfqwrz9xmdwqzqwixkj2";
    };
    meta = {
      description = "Stateful programmatic web browsing in Python, after Andy Lester's Perl module WWW::Mechanize";
      homepage = http://wwwsearch.sourceforge.net/mechanize/;
      license = ["BSD" "ZPL 2.1"];
    };
    pyCheck = "from mechanize import Browser";
  };

  pexpect = t.pythonLibSetup.merge {
    name = "pexpect-2.3";
    src = fetchurl {
      url = mirror://sourceforge/pexpect/pexpect-2.3.tar.gz;
      sha256 = "0x8bfjjqygriry1iyygm5048ykl5qpbpzqfp6i8dhkslm3ryf5fk";
    };
    meta = {
      description = "tcl expect as python library";
      homepage = http://www.noah.org/wiki/Pexpect;
      license = "MIT";
    };
  };

  ### python applications

  pythonExStub = composableDerivation {} {
    buildInputs = [p.makeWrapper];
    postPhases = ["wrapExecutables"];
    propagatedBuildInputs = [ t.pythonFull ]; # see [1]

    # adding $out to NIX_PYTHON_SITES because some of those executables seem to come with extra libs
    wrapExecutables = ''
      for prog in $out/bin/*; do
      wrapProgram "$prog" \
                   --set NIX_PYTHON_SITES "$NIX_PYTHON_SITES:$out" \
                   --set PYTHONPATH "\$PYTHONPATH:$out"
      done
    '';
  };

  pitivi = t.pythonExStub.merge {
    name = "pitivi-0.11.2";
    src = fetchurl {
      url = http://ftp.gnome.org/pub/GNOME/sources/pitivi/0.11/pitivi-0.11.2.tar.bz2;
      sha256 = "0d3bqgfp60qm5bf904k477bd8jhxizj1klv84wbxsz9vhjwx9zcl";
    };
    buildInputs = [ t.pygtk212 t.gstPython t.pygoocanvas t.zopeInterface t.dbusPython
      p.intltool p.gettext p.makeWrapper p.gettext ];
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

  istanbul = t.pythonExStub.merge {
    name = "istanbul-0.2.2";
    buildInputs = [ t.pygtk212 t.gstPython /*t.gnomePython (contained in gtk) t.gnomePythonExtras */ t.pythonXlib
      p.perl p.perlXMLParser p.gettext];
    # gstPython can't be imported when building (TODO).. so just run true instead of python
    configurePhase = ''./configure --prefix=""''; # DESTDIR is set below
    postUnpack = ''
      sed -i 's/$PYTHON/true/' istanbul-0.2.2/configure
      mkdir -p $out/bin
      export DESTDIR="$out"
      shopt -s nullglob
    '';
    src = fetchurl {
      url = http://zaheer.merali.org/istanbul-0.2.2.tar.bz2;
      sha256 = "1mdc82d0xs9pyavs616bz0ywq3zwy3h5y0ydjl6kvcgixii29aiv";
    };
    postInstall = "chmod a+x $out/bin/istanbul";
    meta = {
      description = "A non-linear video editor using the GStreamer multimedia framework";
      homepage = http://live.gnome.org/Istanbul;
      license = "LGPLv2";
    };
  };

  all = lib.filter (x:
                   (__isAttrs x)
                && ((lib.maybeAttr "libPython" false x) == t.version)
                && (lib.maybeAttr "name" false x != false) # don't collect pythonLibStub etc
        ) (lib.flattenAttrs (removeAttrs t ["all"])); # nix is not yet lazy enough, so I've to remove all first
}))
