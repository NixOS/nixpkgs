a :  
let 
  fetchurl = a.fetchurl;

  version = a.lib.attrByPath ["version"] "0.83.0" a; 
  buildInputs = with a; [
    pkgconfig
  ];
  propagatedBuildInputs = with a; [
    dbus python dbus_glib
  ];
in
rec {
  src = fetchurl {
    url = "http://dbus.freedesktop.org/releases/dbus-python/dbus-python-${version}.tar.gz";
    sha256 = "14b1fwq9jyvg9qbbrmpk1264s9shm9n638hsgmkh9fn2lmd1vpc9";
  };

  inherit buildInputs propagatedBuildInputs;
  configureFlags = [];

  /* doConfigure should be removed if not needed */
  phaseNames = ["doConfigure" "doMakeInstall"];
      
  name = "python-dbus-" + version;
  meta = {
    description = "Python DBus bindings";
  };
}
