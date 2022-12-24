{ lib
, python27
, callPackage
, ...
}:

let
  python27' = lib.addMetaAttrs {
    # Overriding `meta.knownVulnerabilities` here, see #201859 for why it exists
    # In resholve case this should not be a security issue,
    # since it will only be used during build, not runtime
    knownVulnerabilities = [ ];
  } python27.override {
    # strip down that python version as much as possible
    openssl = null;
    bzip2 = null;
    readline = null;
    ncurses = null;
    gdbm = null;
    sqlite = null;
    rebuildBytecode = false;
    stripBytecode = true;
    strip2to3 = true;
    stripConfig = true;
    stripIdlelib = true;
    stripTests = true;
    stripLibs = [
      # directories
      "bsddb*"
      "curses"
      "compiler"
      "ensurepip"
      "hotshot"
      "lib-tk"
      "sqlite3"
      # files
      "aifc*"
      "antigravity*"
      "async*"
      "*audio*"
      "BaseHTTPServer*"
      "Bastion*"
      "binhex*"
      "bdb*"
      "CGIHTTPServer*"
      "cgitb*"
      "chunk*"
      "colorsys*"
      "dbhash*"
      "dircache*"
      "*dbm*"
      "ftplib*"
      "*hdr*"
      "imaplib*"
      "imputil*"
      "MimeWriter*"
      "mailbox*"
      "mhlib*"
      "mimify*"
      "multifile*"
      "netrc*"
      "nntplib*"
      "os2emxpath*"
      "pyclbr*"
      "pydoc*"
      "SimpleHTTPServer*"
      "sgmllib*"
      "smtp*"
      "ssl*"
      "sun*"
      "tabnanny*"
      "telnetlib*"
      "this*"
      "wave*"
      "webbrowser*"
      "whichdb*"
      "wsgiref*"
      "xdrlib*"
      "*XMLRPC*"
    ];
    enableOptimizations = false;
  };
  source = callPackage ./source.nix { python27 = python27'; };
  deps = callPackage ./deps.nix { python27 = python27'; };
in
rec {
  # resholve itself
  resholve = callPackage ./resholve.nix {
    inherit (source) rSrc version;
    inherit (deps.oil) oildev;
    inherit (deps) configargparse;
    inherit resholve-utils;
  };
  # funcs to validate and phrase invocations of resholve
  # and use those invocations to build packages
  resholve-utils = callPackage ./resholve-utils.nix {
    inherit resholve;
  };
}
