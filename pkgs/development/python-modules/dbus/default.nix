a :  
let 
  fetchurl = a.fetchurl;

  version = a.lib.attrByPath ["version"] "0.83.1" a; 
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
    sha256 = "168vrizxnszh16yk4acpfhy502w8i997d8l3w4i26kxgy433ha6f";
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
